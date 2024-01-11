using UnityEngine;
using UnityEditor;
using UnityEngine.Rendering;

public class LightProbeEditor : MonoBehaviour
{
    public static void ModifyLightProbeBrightness(float brightnessFactor, bool increase)
    {
        SphericalHarmonicsL2[] bakedProbes = LightmapSettings.lightProbes.bakedProbes;

        for (int i = 0; i < bakedProbes.Length; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                for (int k = 0; k < 9; k++)
                {
                    // If increase is true, we divide to increase brightness
                    // Otherwise, we multiply to reduce brightness
                    bakedProbes[i][j, k] = increase ? bakedProbes[i][j, k] / brightnessFactor : bakedProbes[i][j, k] * brightnessFactor;
                }
            }
        }

        LightmapSettings.lightProbes.bakedProbes = bakedProbes;

        Debug.Log(increase ? "Light Probe Brightness Increased" : "Light Probe Brightness Lowered");
    }
}

public class LightProbeEditorWindow : EditorWindow
{
    private float brightnessFactor = 0.5f;

    [MenuItem("Window/Light Probe Editor")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(LightProbeEditorWindow));
    }

    void OnGUI()
    {
        GUILayout.Label("Modify Light Probe Brightness", EditorStyles.boldLabel);

        brightnessFactor = EditorGUILayout.Slider("Brightness Factor", brightnessFactor, 0f, 1f);

        if (GUILayout.Button("Lower Brightness"))
        {
            LightProbeEditor.ModifyLightProbeBrightness(brightnessFactor, false);
        }

        if (GUILayout.Button("Increase Brightness"))
        {
            LightProbeEditor.ModifyLightProbeBrightness(brightnessFactor, true);
        }
    }
}