using UnityEngine;
using UnityEditor;

public class FitCameraToQuad : EditorWindow
{
    private Camera selectedCamera;
    private Transform quadTransform;
    private bool fitToHeight = true;

    [MenuItem("Tools/Fit Camera to Quad")]
    public static void ShowWindow()
    {
        GetWindow(typeof(FitCameraToQuad), true, "Fit Camera to Quad");
    }

    void OnGUI()
    {
        GUILayout.Label("Fit Camera to Quad Settings", EditorStyles.boldLabel);

        selectedCamera = (Camera)EditorGUILayout.ObjectField("Camera", selectedCamera, typeof(Camera), true);
        quadTransform = (Transform)EditorGUILayout.ObjectField("Quad Transform", quadTransform, typeof(Transform), true);

        fitToHeight = EditorGUILayout.Toggle("Fit to Quad Height", fitToHeight);
        
        if (GUILayout.Button("Fit Camera"))
        {
            if (selectedCamera != null && quadTransform != null)
            {
                FitCamera();
            }
            else
            {
                EditorUtility.DisplayDialog("Error", "Please assign both a camera and a quad transform.", "OK");
            }
        }
    }

    void FitCamera()
    {
        if (fitToHeight)
        {
            selectedCamera.orthographicSize = quadTransform.localScale.y / 2;
        }
        else
        {
            selectedCamera.orthographicSize = quadTransform.localScale.x / 2 / selectedCamera.aspect;
        }

        EditorUtility.SetDirty(selectedCamera);  // Marks the camera settings as changed
        Debug.Log("Camera fitted based on " + (fitToHeight ? "height" : "width") + ".");
    }
}
