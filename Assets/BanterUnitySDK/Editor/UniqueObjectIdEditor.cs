using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(UniqueObjectId))]
public class UniqueObjectIdEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        UniqueObjectId script = (UniqueObjectId)target;
        SerializedObject serializedObject = new SerializedObject(script);

        if(GUILayout.Button("Generate New ID"))
        {
            script.ButtonGen();
            serializedObject.Update(); // Update the serialized object
            serializedObject.ApplyModifiedProperties(); // Apply changes to the serialized object
            EditorUtility.SetDirty(script); // Mark the object as dirty to ensure the ID change is saved
            Repaint(); // Force the Inspector to repaint and show the updated value
        }
    }
}