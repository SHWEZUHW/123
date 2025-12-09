using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class AssetBundleExtractorWindow : EditorWindow
{
    string bundlePath = "";
    AssetBundle bundle;
    string[] assetNames = new string[0];
    int selectedIndex;

    const string OutFolder = "Assets/ExtractedFromAssetBundle";

    [MenuItem("Tools/AssetBundle/Extractor")]
    static void Open() => GetWindow<AssetBundleExtractorWindow>("AB Extractor");

    void OnDisable() => Unload();

    void OnGUI()
    {
        EditorGUILayout.LabelField("AssetBundle file", EditorStyles.boldLabel);

        using (new EditorGUILayout.HorizontalScope())
        {
            bundlePath = EditorGUILayout.TextField(bundlePath);
            if (GUILayout.Button("Browse", GUILayout.Width(70)))
            {
                var p = EditorUtility.OpenFilePanel("Select AssetBundle", "", "");
                if (!string.IsNullOrEmpty(p)) bundlePath = p;
            }
        }

        using (new EditorGUILayout.HorizontalScope())
        {
            GUI.enabled = !string.IsNullOrEmpty(bundlePath);
            if (GUILayout.Button("Load")) Load(bundlePath);

            GUI.enabled = bundle != null;
            if (GUILayout.Button("Unload")) Unload();
            GUI.enabled = true;
        }

        EditorGUILayout.Space();

        if (bundle == null)
        {
            EditorGUILayout.HelpBox("Load an AssetBundle to list and extract assets.", MessageType.Info);
            return;
        }

        if (assetNames.Length == 0)
        {
            EditorGUILayout.HelpBox("Bundle has no named assets.", MessageType.Warning);
            return;
        }

        selectedIndex = Mathf.Clamp(selectedIndex, 0, assetNames.Length - 1);
        selectedIndex = EditorGUILayout.Popup("Asset", selectedIndex, assetNames);

        using (new EditorGUILayout.HorizontalScope())
        {
            if (GUILayout.Button("Extract Selected To Project"))
                ExtractSelected();

            if (GUILayout.Button("Instantiate Selected"))
                InstantiateSelected();
        }

        EditorGUILayout.Space();
        EditorGUILayout.HelpBox(
            "Note: AssetBundles don't contain original source files. This extracts copies of supported assets into Assets/.\n" +
            "Supported: GameObject prefabs, Materials, Meshes, AnimationClips, ScriptableObjects.\n" +
            "Textures and AudioClips are not handled here (can be added).",
            MessageType.None
        );
    }

    void Load(string path)
    {
        Unload();

        if (!File.Exists(path))
        {
            EditorUtility.DisplayDialog("File not found", path, "OK");
            return;
        }

        bundle = AssetBundle.LoadFromFile(path);
        if (bundle == null)
        {
            EditorUtility.DisplayDialog("Load failed", "Not a valid AssetBundle.", "OK");
            return;
        }

        assetNames = bundle.GetAllAssetNames();
        selectedIndex = 0;
        Debug.Log($"Loaded AssetBundle ({assetNames.Length} assets): {Path.GetFileName(path)}");
    }

    void Unload()
    {
        if (bundle != null)
        {
            bundle.Unload(false);
            bundle = null;
        }
        assetNames = new string[0];
        selectedIndex = 0;
    }

    void InstantiateSelected()
    {
        var name = assetNames[selectedIndex];
        var go = bundle.LoadAsset<GameObject>(name);
        if (go == null)
        {
            EditorUtility.DisplayDialog("Not a GameObject", "Selected asset is not a GameObject.", "OK");
            return;
        }

        var instance = (GameObject)PrefabUtility.InstantiatePrefab(go);
        if (instance == null) instance = Instantiate(go);
        Undo.RegisterCreatedObjectUndo(instance, "Instantiate from AssetBundle");
        Selection.activeGameObject = instance;
    }

    void ExtractSelected()
    {
        EnsureFolder(OutFolder);

        var name = assetNames[selectedIndex];

        // Try to load as GameObject first (common case: prefab)
        var go = bundle.LoadAsset<GameObject>(name);
        if (go != null)
        {
            ExtractPrefab(go);
            return;
        }

        // Otherwise: extract as supported single asset
        var obj = bundle.LoadAsset<Object>(name);
        if (obj == null)
        {
            EditorUtility.DisplayDialog("Failed", "Could not load the selected asset.", "OK");
            return;
        }

        if (obj is Material || obj is Mesh || obj is AnimationClip || obj is ScriptableObject)
        {
            CreateProjectAssetCopy(obj);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            return;
        }

        EditorUtility.DisplayDialog(
            "Unsupported type",
            $"Type '{obj.GetType().Name}' is not handled by this extractor yet.",
            "OK"
        );
    }

    void ExtractPrefab(GameObject prefabFromBundle)
    {
        EnsureFolder(OutFolder);

        // Instantiate hidden so we can save it as a prefab asset
        var instance = (GameObject)PrefabUtility.InstantiatePrefab(prefabFromBundle);
        if (instance == null) instance = Instantiate(prefabFromBundle);
        instance.name = prefabFromBundle.name;

        try
        {
            var prefabPath = AssetDatabase.GenerateUniqueAssetPath(
                $"{OutFolder}/{Sanitize(prefabFromBundle.name)}.prefab"
            );

            var savedPrefab = PrefabUtility.SaveAsPrefabAsset(instance, prefabPath);

            // Duplicate supported dependencies into Assets and remap references in the prefab
            var map = DuplicateDependencies(savedPrefab, OutFolder);
            RemapObjectReferences(savedPrefab, map);

            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            Selection.activeObject = savedPrefab;
            EditorGUIUtility.PingObject(savedPrefab);
            Debug.Log($"Extracted prefab to: {prefabPath}");
        }
        finally
        {
            DestroyImmediate(instance);
        }
    }

    static Object CreateProjectAssetCopy(Object src)
    {
        var copy = Instantiate(src);
        copy.name = src.name;

        var ext =
            src is Material ? "mat" :
            src is AnimationClip ? "anim" :
            "asset";

        var path = AssetDatabase.GenerateUniqueAssetPath(
            $"{OutFolder}/{Sanitize(src.name)}.{ext}"
        );

        AssetDatabase.CreateAsset(copy, path);
        Selection.activeObject = copy;
        EditorGUIUtility.PingObject(copy);
        Debug.Log($"Created asset: {path}");
        return copy;
    }

    static Dictionary<Object, Object> DuplicateDependencies(GameObject prefabAsset, string outFolder)
    {
        var map = new Dictionary<Object, Object>();
        var deps = EditorUtility.CollectDependencies(new Object[] { prefabAsset });

        foreach (var dep in deps)
        {
            if (dep == null) continue;
            if (AssetDatabase.Contains(dep)) continue; // already in project
            if (dep is GameObject) continue;
            if (dep is Component) continue;

            if (dep is Material || dep is Mesh || dep is AnimationClip || dep is ScriptableObject)
            {
                var copy = Instantiate(dep);
                copy.name = dep.name;

                var ext =
                    dep is Material ? "mat" :
                    dep is AnimationClip ? "anim" :
                    "asset";

                var path = AssetDatabase.GenerateUniqueAssetPath(
                    $"{outFolder}/{Sanitize(dep.name)}.{ext}"
                );

                AssetDatabase.CreateAsset(copy, path);
                map[dep] = copy;
            }
        }

        return map;
    }

    static void RemapObjectReferences(GameObject prefabAsset, Dictionary<Object, Object> map)
    {
        if (map == null || map.Count == 0) return;

        var comps = prefabAsset.GetComponentsInChildren<Component>(true);
        foreach (var c in comps)
        {
            if (c == null) continue; // missing script
            var so = new SerializedObject(c);
            var it = so.GetIterator();
            var changed = false;

            while (it.NextVisible(true))
            {
                if (it.propertyType != SerializedPropertyType.ObjectReference) continue;
                var oldObj = it.objectReferenceValue;
                if (oldObj == null) continue;

                if (map.TryGetValue(oldObj, out var newObj))
                {
                    it.objectReferenceValue = newObj;
                    changed = true;
                }
            }

            if (changed)
            {
                so.ApplyModifiedPropertiesWithoutUndo();
                EditorUtility.SetDirty(c);
            }
        }

        EditorUtility.SetDirty(prefabAsset);
    }

    static void EnsureFolder(string path)
    {
        if (AssetDatabase.IsValidFolder(path)) return;

        var parts = path.Split('/');
        var cur = parts[0];
        for (int i = 1; i < parts.Length; i++)
        {
            var next = cur + "/" + parts[i];
            if (!AssetDatabase.IsValidFolder(next))
                AssetDatabase.CreateFolder(cur, parts[i]);
            cur = next;
        }
    }

    static string Sanitize(string s)
    {
        foreach (var ch in Path.GetInvalidFileNameChars())
            s = s.Replace(ch, '_');
        return string.IsNullOrEmpty(s) ? "Asset" : s;
    }
}
