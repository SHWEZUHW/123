using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class GradientLightControllerWindow : EditorWindow
{
    private List<Light> lights = new List<Light>();
    private Color startColor = Color.white;
    private Color endColor = Color.white;
	private bool useFullHueRange = false;

    [MenuItem("Banter/Tools/Gradient Light Controller")]
    public static void ShowWindow()
    {
        GetWindow<GradientLightControllerWindow>("Gradient Light Controller");
    }

    void OnGUI()
    {
        GUILayout.Label("Gradient Light Controller", EditorStyles.boldLabel);

        // Drag and drop field for multiple lights
        EditorGUILayout.HelpBox("Drag and drop Light objects here", MessageType.Info);
        Rect dropArea = GUILayoutUtility.GetRect(0.0f, 50.0f, GUILayout.ExpandWidth(true));
        GUI.Box(dropArea, "Add Lights");

        if (Event.current.type == EventType.DragUpdated && dropArea.Contains(Event.current.mousePosition))
        {
            DragAndDrop.visualMode = DragAndDropVisualMode.Copy;
            Event.current.Use();
        }
        else if (Event.current.type == EventType.DragPerform && dropArea.Contains(Event.current.mousePosition))
        {
            DragAndDrop.AcceptDrag();
            foreach (Object draggedObject in DragAndDrop.objectReferences)
            {
                // Check if dragged object is a Light or a GameObject with a Light component
                Light light = draggedObject as Light ?? (draggedObject as GameObject)?.GetComponent<Light>();
                if (light != null && !lights.Contains(light))
                {
                    lights.Add(light);
                }
            }
            Event.current.Use();
        }

        // Display list of lights
        for (int i = 0; i < lights.Count; i++)
        {
            lights[i] = (Light)EditorGUILayout.ObjectField("Light " + (i + 1), lights[i], typeof(Light), true);
        }

        // Color pickers for start and end colors
        startColor = EditorGUILayout.ColorField("Start Color", startColor);
        endColor = EditorGUILayout.ColorField("End Color", endColor);
		
		// Toggle for full hue range interpolation
        useFullHueRange = EditorGUILayout.Toggle("Use Full Hue Range", useFullHueRange);


        // Button to set colors
        if (GUILayout.Button("Set Color"))
        {
            SetGradientColors();
        }
    }

    private void SetGradientColors()
    {
        if (lights.Count == 0) return;

        // Convert start and end colors to HSV
        Color.RGBToHSV(startColor, out float startH, out float startS, out float startV);
        Color.RGBToHSV(endColor, out float endH, out float endS, out float endV);

        // Ensure the hue interpolation goes from the lowest to highest hue
        if (useFullHueRange && endH < startH)
        {
            endH += 1.0f; // Wrap around the hue wheel
        }

        for (int i = 0; i < lights.Count; i++)
        {
            if (lights[i] != null)
            {
                float t = (float)i / (lights.Count - 1);
                float interpolatedHue = Mathf.Lerp(startH, endH, t) % 1.0f; // Wrap hue back into [0, 1] range
                float interpolatedSaturation = Mathf.Lerp(startS, endS, t);
                float interpolatedValue = Mathf.Lerp(startV, endV, t);

                lights[i].color = Color.HSVToRGB(interpolatedHue, interpolatedSaturation, interpolatedValue);
            }
        }
    }
}
