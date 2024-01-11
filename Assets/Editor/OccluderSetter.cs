using UnityEngine;
using UnityEditor;

public class DisableOccluderForSmallOrTransparentObjects : EditorWindow
{
    float minSize = 1.0f;
    bool disableForTransparent = true;

    [MenuItem("Banter/Tools/Disable Occluder")]
    public static void ShowWindow()
    {
        GetWindow<DisableOccluderForSmallOrTransparentObjects>("Disable Occluder");
    }

    void OnGUI()
    {
        
        minSize = EditorGUILayout.FloatField("Bound Size", minSize);

        
        disableForTransparent = EditorGUILayout.Toggle("Disable for Transparent", disableForTransparent);

        if (GUILayout.Button("Disable Occluder"))
        {
            DisableOccluder();
        }
    }

    void DisableOccluder()
    {
        foreach (GameObject obj in FindObjectsOfType<GameObject>())
        {
            Renderer renderer = obj.GetComponent<Renderer>();
            if (renderer != null)
            {
                // Check for bounding box size
                Bounds bounds = renderer.bounds;
                bool disableOccluder = bounds.size.magnitude < minSize;

                // Check for non-opaque render type in materials
                if (!disableOccluder && disableForTransparent)
                {
                    foreach (Material mat in renderer.sharedMaterials)
                    {
                        if (mat != null && mat.shader != null && mat.GetTag("RenderType", false) != "Opaque")
                        {
                            disableOccluder = true;
                            break;
                        }
                    }
                }

                // Disable occluder if conditions are met
                if (disableOccluder)
                {
                    StaticEditorFlags flags = GameObjectUtility.GetStaticEditorFlags(obj);
                    flags &= ~StaticEditorFlags.OccluderStatic;
                    GameObjectUtility.SetStaticEditorFlags(obj, flags);
                    Debug.Log("Occluder disabled for: " + obj.name);
                }
            }
        }
    }
}