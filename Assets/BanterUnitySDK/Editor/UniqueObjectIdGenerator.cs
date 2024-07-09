using UnityEditor;
using UnityEngine;

public class UniqueObjectIdGenerator : EditorWindow
{
    [MenuItem("Tools/Generate Unique IDs")]
    public static void ShowWindow()
    {
        GetWindow<UniqueObjectIdGenerator>("Generate Unique IDs");
    }

    private void OnGUI()
    {
        if (GUILayout.Button("Generate Unique IDs for All Objects"))
        {
            GenerateUniqueIDs();
        }
    }

    private void GenerateUniqueIDs()
    {
        var objectsWithUniqueId = FindObjectsOfType<UniqueObjectId>();

        foreach (var obj in objectsWithUniqueId)
        {
            obj.ButtonGen();
            EditorUtility.SetDirty(obj); // Mark the object as dirty so the change gets saved
        }

        Debug.Log($"Generated new unique IDs for {objectsWithUniqueId.Length} objects.");
    }
}
