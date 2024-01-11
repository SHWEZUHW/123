using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class JointCreator : EditorWindow
{
    private GameObject selectedObject;
    private Rigidbody selectedRigidbody;
    private JointType jointType;
    private List<GameObject> objectsList = new List<GameObject>(); // New list for storing objects

    // Enum for selecting the joint type
    private enum JointType
    {
        Hinge,
        Fixed,
        Spring
    }

    [MenuItem("Banter/Tools/Joint Creator")]
    private static void ShowWindow()
    {
        var window = GetWindow<JointCreator>();
        window.titleContent = new GUIContent("Joint Creator");
        window.Show();
    }

    private void OnGUI()
{
    GUILayout.Label("Joint Creator", EditorStyles.boldLabel);

    // Button to clear the list
    if (objectsList.Count > 0)
    {
        if (GUILayout.Button("Clear List"))
        {
            objectsList.Clear();
        }
    }

    // Dropdown for selecting the joint type
    jointType = (JointType)EditorGUILayout.EnumPopup("Joint Type", jointType);

    // Drag and drop area for GameObjects
    EditorGUILayout.HelpBox("Drag and drop GameObjects here", MessageType.Info);
    Rect dropArea = GUILayoutUtility.GetRect(0.0f, 50.0f, GUILayout.ExpandWidth(true));
    GUI.Box(dropArea, "Add Objects");

    // Handle drag and drop events
    if (Event.current.type == EventType.DragUpdated && dropArea.Contains(Event.current.mousePosition))
    {
        DragAndDrop.visualMode = DragAndDropVisualMode.Copy;
        Event.current.Use();
    }

    if (Event.current.type == EventType.DragPerform && dropArea.Contains(Event.current.mousePosition))
    {
        DragAndDrop.AcceptDrag();
        foreach (Object draggedObject in DragAndDrop.objectReferences)
        {
            GameObject draggedGameObject = draggedObject as GameObject;
            if (draggedGameObject != null)
            {
                // Check if dragging a single object with children
                if (DragAndDrop.objectReferences.Length == 1 && draggedGameObject.transform.childCount > 0)
                {
                    foreach (Transform child in draggedGameObject.transform)
                    {
                        if (!objectsList.Contains(child.gameObject))
                        {
                            objectsList.Add(child.gameObject);
                        }
                    }
                }
                else if (!objectsList.Contains(draggedGameObject)) // Add only the parent object if multiple objects are dragged
                {
                    objectsList.Add(draggedGameObject);
                }
            }
        }
        Event.current.Use();
    }

    // Display the objects in the list
    GUILayout.Label("Objects to Connect:", EditorStyles.boldLabel);
    foreach (GameObject obj in objectsList)
    {
        EditorGUILayout.ObjectField(obj, typeof(GameObject), true);
    }

    // Button to create joints
    if (GUILayout.Button("Create Joints"))
    {
        foreach (GameObject obj in objectsList)
        {
            CreateJoint(obj);
        }
    }
}



    private void CreateJoint(GameObject obj)
    {
        Rigidbody objRigidbody = obj.GetComponent<Rigidbody>();

        if (objRigidbody == null)
        {
            objRigidbody = obj.AddComponent<Rigidbody>();
        }

        switch (jointType)
        {
            case JointType.Hinge:
                var hingeJoint = obj.AddComponent<HingeJoint>();
                hingeJoint.connectedBody = selectedRigidbody;
                break;
            case JointType.Fixed:
                var fixedJoint = obj.AddComponent<FixedJoint>();
                fixedJoint.connectedBody = selectedRigidbody;
                break;
            case JointType.Spring:
                var springJoint = obj.AddComponent<SpringJoint>();
                springJoint.connectedBody = selectedRigidbody;
                break;
        }
    }
}
