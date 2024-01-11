using UnityEngine;
using UnityEditor;
using UnityEngine.Rendering;

public class LightProbePlacerWindow : EditorWindow
{
    private LightProbeGroup group;
    private bool placingMode;
    private float yOffset = 0.25f;
    private float brightnessFactor = 0.5f; // Add brightness factor

    [MenuItem("Window/Light Probe Placer")]
    public static void ShowWindow()
    {
        GetWindow<LightProbePlacerWindow>("Light Probe Placer");
    }

    private void OnGUI()
    {
        group = (LightProbeGroup)EditorGUILayout.ObjectField("Light Probe Group", group, typeof(LightProbeGroup), true);
        yOffset = EditorGUILayout.FloatField("Y Offset", yOffset);

        // Toggle button for placing mode
        placingMode = EditorGUILayout.Toggle("Place Probes", placingMode);

        // Add controls for brightness modification
        GUILayout.Label("Modify Light Probe Brightness", EditorStyles.boldLabel);
        brightnessFactor = EditorGUILayout.Slider("Brightness Factor", brightnessFactor, 0f, 1f);
        if (GUILayout.Button("Lower Brightness"))
        {
            ModifyLightProbeBrightness(brightnessFactor, false);
        }
        if (GUILayout.Button("Increase Brightness"))
        {
            ModifyLightProbeBrightness(brightnessFactor, true);
        }
    }

    private void ModifyLightProbeBrightness(float brightnessFactor, bool increase)
    {
        SphericalHarmonicsL2[] bakedProbes = LightmapSettings.lightProbes.bakedProbes;

        for (int i = 0; i < bakedProbes.Length; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                for (int k = 0; k < 9; k++)
                {
                    bakedProbes[i][j, k] = increase ? bakedProbes[i][j, k] / brightnessFactor : bakedProbes[i][j, k] * brightnessFactor;
                }
            }
        }

        LightmapSettings.lightProbes.bakedProbes = bakedProbes;
        Debug.Log(increase ? "Light Probe Brightness Increased" : "Light Probe Brightness Lowered");
    }

    private void OnSceneGUI(SceneView sceneView)
    {
        if (!placingMode || group == null) return;

        // Set up a control ID for our GUI
        int controlId = GUIUtility.GetControlID(FocusType.Passive);

        // Handle mouse click events
        if (Event.current.type == EventType.MouseDown && Event.current.button == 0)
        {
            Ray worldRay = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);
            RaycastHit hitInfo;

            if (Physics.Raycast(worldRay, out hitInfo))
            {
                Undo.RecordObject(group, "Modify Light Probes");

                if (Event.current.control)
                {
                    // Control key is pressed, remove the closest light probe
                    Vector3 clickedPosition = group.transform.InverseTransformPoint(hitInfo.point + new Vector3(0, yOffset, 0));
                    Vector3[] oldPositions = group.probePositions;
                    int closestProbeIndex = 0;
                    float closestDistance = Vector3.Distance(oldPositions[0], clickedPosition);

                    for (int i = 1; i < oldPositions.Length; i++)
                    {
                        float distance = Vector3.Distance(oldPositions[i], clickedPosition);
                        if (distance < closestDistance)
                        {
                            closestDistance = distance;
                            closestProbeIndex = i;
                        }
                    }

                    Vector3[] newPositions = new Vector3[oldPositions.Length - 1];
                    int j = 0;
                    for (int i = 0; i < oldPositions.Length; i++)
                    {
                        if (i != closestProbeIndex)
                        {
                            newPositions[j] = oldPositions[i];
                            j++;
                        }
                    }

                    group.probePositions = newPositions;
                }
                else
                {
                    // Control key is not pressed, add a new light probe
                    Vector3 newPosition = hitInfo.point + new Vector3(0, yOffset, 0);
                    Vector3[] oldPositions = group.probePositions;
                    Vector3[] newPositions = new Vector3[oldPositions.Length + 1];
                    oldPositions.CopyTo(newPositions, 0);
                    newPositions[oldPositions.Length] = group.transform.InverseTransformPoint(newPosition);
                    group.probePositions = newPositions;
                }

                Event.current.Use();
            }
        }

        // Handle the GUI
        HandleUtility.AddDefaultControl(controlId);
    }

    private void OnEnable()
    {
        SceneView.duringSceneGui += OnSceneGUI;
    }

    private void OnDisable()
    {
        SceneView.duringSceneGui -= OnSceneGUI;
    }
}
