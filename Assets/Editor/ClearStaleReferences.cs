using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public class ClearStaleReferences : EditorWindow
{
    [MenuItem("Banter/Tools/Clear Stale References")]
    public static void ShowWindow()
    {
        GetWindow<ClearStaleReferences>("Clear Stale References");
    }

    private void OnGUI()
    {
        GUILayout.Label("Clear Stale References in Active Scene", EditorStyles.boldLabel);

        if (GUILayout.Button("Clear Stale References"))
        {
            ClearReferencesInScene();
        }
    }

    private static void ClearReferencesInScene()
    {
        // Find all objects in the scene
        GameObject[] allObjects = Resources.FindObjectsOfTypeAll<GameObject>();

        foreach (GameObject obj in allObjects)
        {
            if (obj.hideFlags == HideFlags.NotEditable || obj.hideFlags == HideFlags.HideAndDontSave)
                continue;

            // Clear references in components
            Component[] components = obj.GetComponents<Component>();
            foreach (Component component in components)
            {
                if (component == null) continue;

                SerializedObject so = new SerializedObject(component);
                SerializedProperty sp = so.GetIterator();
                while (sp.NextVisible(true))
                {
                    if (sp.propertyType == SerializedPropertyType.ObjectReference)
                    {
                        if (sp.objectReferenceValue is Texture)
                        {
                            sp.objectReferenceValue = null;
                        }
                    }
                }
                so.ApplyModifiedProperties();
            }
        }

        // Save the scene
        EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        EditorSceneManager.SaveOpenScenes();
        Debug.Log("Cleared stale references in the active scene.");
    }
}
