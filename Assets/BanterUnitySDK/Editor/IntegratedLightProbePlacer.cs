using UnityEngine;
using UnityEditor;
using UnityEngine.Rendering;
using UnityEngine.AI;
using System.Collections.Generic;

public class IntegratedLightProbePlacer : EditorWindow
{
    private LightProbeGroup lightProbeGroup;
    private bool placingMode;
    private float yOffset = 0.25f; // Shared Y Offset
    private float brightnessFactor = 0.5f; // Brightness factor from the first script
    private float gridDensity = 0f; // From the second script
    private float mergeDistance = 1f; // From the second script
	private GameObject volumeMeshObject;
	private float volumeProbeSpacing = 1.0f;

    [MenuItem("Banter/Tools/Light Probe Placer")]
    public static void ShowWindow()
    {
        GetWindow<IntegratedLightProbePlacer>("Light Probe Placer");
    }

    private void OnGUI()
    {
        // Common Light Probe Group field
        lightProbeGroup = (LightProbeGroup)EditorGUILayout.ObjectField("Light Probe Group", lightProbeGroup, typeof(LightProbeGroup), true);


        // Section for Volume-based Probe Placement
        GUILayout.Label("Auto Light Probe Placement", EditorStyles.boldLabel);
		gridDensity = EditorGUILayout.FloatField("Grid Density", gridDensity);
        volumeMeshObject = (GameObject)EditorGUILayout.ObjectField("Volume Mesh Object", volumeMeshObject, typeof(GameObject), true);


		if (GUILayout.Button(new GUIContent("Place Light Probes in Volume", " Use Grid density of 0.1. The higher the Grid Density value, the more probes will be placed.")))
		{
			PlaceProbesInVolume();
		}

		if (GUILayout.Button(new GUIContent("Place Light Probes on NavMesh", "Use Grid density of 1. The smaller the Grid Density value, the more probes will be placed.")))
		{
			PlaceLightProbes();
		}

		
		mergeDistance = EditorGUILayout.FloatField("Merge Distance", mergeDistance);
        if (GUILayout.Button("Merge Light Probes"))
        {
            MergeLightProbes();
        }
		
		// Tab or Section for Placing and Modifying Brightness (from the first script)
        GUILayout.Label("Manual Light Probe Placement", EditorStyles.boldLabel);
        placingMode = EditorGUILayout.Toggle("Place Probes Mode", placingMode);
		yOffset = EditorGUILayout.FloatField("Y Offset", yOffset);
		
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
        // Method from the first script
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

private void PlaceProbesInVolume()
{
    if (volumeMeshObject == null)
    {
        Debug.LogError("Volume Mesh Object is not set.");
        return;
    }

    if (lightProbeGroup == null)
    {
        lightProbeGroup = volumeMeshObject.GetComponent<LightProbeGroup>();
        if (lightProbeGroup == null)
        {
            lightProbeGroup = volumeMeshObject.AddComponent<LightProbeGroup>();
        }
    }

    Bounds bounds = CalculateScaledBounds(volumeMeshObject);
    float probeSpacing = CalculateProbeSpacing(bounds, gridDensity);
    List<Vector3> probePositions = new List<Vector3>();

    // Transform the bounds to world space before iterating
    Vector3 worldMin = volumeMeshObject.transform.TransformPoint(bounds.min);
    Vector3 worldMax = volumeMeshObject.transform.TransformPoint(bounds.max);

    for (float x = worldMin.x; x <= worldMax.x; x += probeSpacing)
    {
        for (float y = worldMin.y; y <= worldMax.y; y += probeSpacing)
        {
            for (float z = worldMin.z; z <= worldMax.z; z += probeSpacing)
            {
                Vector3 worldPosition = new Vector3(x, y, z);
                // Ensure we are placing probes inside the collider bounds
                if (volumeMeshObject.GetComponent<Collider>().bounds.Contains(worldPosition))
                {
                    // Add the point in the local space of the LightProbeGroup
                    probePositions.Add(lightProbeGroup.transform.InverseTransformPoint(worldPosition));
                }
            }
        }
    }

    lightProbeGroup.probePositions = probePositions.ToArray();
    Debug.Log($"Placed {probePositions.Count} light probes inside the volume.");
}

private Bounds CalculateScaledBounds(GameObject obj)
{
    MeshFilter meshFilter = obj.GetComponent<MeshFilter>();
    if (meshFilter == null)
    {
        Debug.LogError("MeshFilter component not found.");
        return new Bounds();
    }

    Mesh mesh = meshFilter.sharedMesh;
    Bounds bounds = mesh.bounds;
    // Apply the object's scale to the bounds
    bounds.size = Vector3.Scale(bounds.size, obj.transform.localScale);
    return bounds;
}


private float CalculateProbeSpacing(Bounds bounds, float density)
{
    // Make sure density is positive and non-zero to avoid division by zero
    if (density <= 0f)
    {
        Debug.LogError("Density must be greater than zero.");
        return 0f;
    }

    // Calculate the approximate spacing needed to achieve the desired density
    float volume = bounds.size.x * bounds.size.y * bounds.size.z;
    float targetProbeCount = density * volume;
    float spacing = Mathf.Pow(volume / targetProbeCount, 1f / 3f);

    return spacing;
}


private bool IsPointInsideMesh(Vector3 point, GameObject obj)
{
    Collider collider = obj.GetComponent<Collider>();
    if (collider == null)
    {
        Debug.LogWarning("No Collider component found on the object, cannot verify if the point is inside the mesh.");
        return false;
    }
    return collider.bounds.Contains(obj.transform.InverseTransformPoint(point));
}


private void PlaceLightProbes()
    {
        if (lightProbeGroup == null)
        {
            Debug.LogError("LightProbeGroup is not assigned!");
            return;
        }

        NavMeshTriangulation navMeshData = NavMesh.CalculateTriangulation();

        // Calculate NavMesh bounds
        Bounds navMeshBounds = new Bounds(navMeshData.vertices[0], Vector3.zero);
        foreach (Vector3 vertex in navMeshData.vertices)
        {
            navMeshBounds.Encapsulate(vertex);
        }

        List<Vector3> probePositions = new List<Vector3>();

        float totalPoints = (navMeshBounds.size.x / gridDensity) * (navMeshBounds.size.z / gridDensity) + navMeshData.vertices.Length;
        int currentPoint = 0;

        // Place probes on NavMesh surface
        for (float x = navMeshBounds.min.x; x < navMeshBounds.max.x; x += gridDensity)
        {
            for (float z = navMeshBounds.min.z; z < navMeshBounds.max.z; z += gridDensity)
            {
                if (EditorUtility.DisplayCancelableProgressBar("Placing Light Probes", "Placing probe " + currentPoint + "/" + totalPoints, currentPoint / totalPoints))
                {
                    // If the user canceled, stop the operation
                    EditorUtility.ClearProgressBar();
                    return;
                }

                Vector3 samplePosition = new Vector3(x, navMeshBounds.max.y, z);
                NavMeshHit hit;
                if (NavMesh.SamplePosition(samplePosition, out hit, navMeshBounds.size.y, NavMesh.AllAreas))
                {
                    // Use the Y offset
                    probePositions.Add(hit.position + Vector3.up * yOffset);
                }

                currentPoint++;
            }
        }

        // Place probes on NavMesh edges
        foreach (Vector3 sourceVertex in navMeshData.vertices)
        {
            if (EditorUtility.DisplayCancelableProgressBar("Placing Light Probes", "Placing probe " + currentPoint + "/" + totalPoints, currentPoint / totalPoints))
            {
                // If the user canceled, stop the operation
                EditorUtility.ClearProgressBar();
                return;
            }

            Vector3 closestEdgePoint = sourceVertex;

            foreach (Vector3 edgeVertex in navMeshData.vertices)
            {
                if ((sourceVertex - edgeVertex).sqrMagnitude < gridDensity * gridDensity)
                {
                    closestEdgePoint = edgeVertex;
                }
            }

            // Use the Y offset
            probePositions.Add(closestEdgePoint + Vector3.up * yOffset);
            currentPoint++;
        }

        lightProbeGroup.probePositions = probePositions.ToArray();

        // Print the count of light probes
        Debug.Log("Light probes placed: " + lightProbeGroup.probePositions.Length);

        // Clear the progress bar when finished
        EditorUtility.ClearProgressBar();
    }

    private void MergeLightProbes()
    {
        if (lightProbeGroup == null)
        {
            Debug.LogError("LightProbeGroup is not assigned!");
            return;
        }

        List<Vector3> mergedProbes = new List<Vector3>();

        foreach (Vector3 probe in lightProbeGroup.probePositions)
        {
            bool merged = false;

            for (int i = 0; i < mergedProbes.Count; i++)
            {
                if ((mergedProbes[i] - probe).sqrMagnitude < mergeDistance * mergeDistance)
                {
                    mergedProbes[i] = (mergedProbes[i] + probe) / 2f;
                    merged = true;
                    break;
                }
            }

            if (!merged)
            {
                mergedProbes.Add(probe);
            }
        }

        lightProbeGroup.probePositions = mergedProbes.ToArray();

        lightProbeGroup.probePositions = mergedProbes.ToArray();

        // Print the count of light probes after merging
        Debug.Log("Light probes after merging: " + lightProbeGroup.probePositions.Length);

    }

    private void OnSceneGUI(SceneView sceneView)
    {
        if (!placingMode || lightProbeGroup == null) return;

        // Set up a control ID for our GUI
        int controlId = GUIUtility.GetControlID(FocusType.Passive);

        // Handle mouse click events
        if (Event.current.type == EventType.MouseDown && Event.current.button == 0)
        {
            Ray worldRay = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);
            RaycastHit hitInfo;

            if (Physics.Raycast(worldRay, out hitInfo))
            {
                Undo.RecordObject(lightProbeGroup, "Modify Light Probes");

                if (Event.current.control)
                {
                    // Control key is pressed, remove the closest light probe
                    Vector3 clickedPosition = lightProbeGroup.transform.InverseTransformPoint(hitInfo.point + new Vector3(0, yOffset, 0));
                    Vector3[] oldPositions = lightProbeGroup.probePositions;
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

                    lightProbeGroup.probePositions = newPositions;
                }
                else
                {
                    // Control key is not pressed, add a new light probe
                    Vector3 newPosition = hitInfo.point + new Vector3(0, yOffset, 0);
                    Vector3[] oldPositions = lightProbeGroup.probePositions;
                    Vector3[] newPositions = new Vector3[oldPositions.Length + 1];
                    oldPositions.CopyTo(newPositions, 0);
                    newPositions[oldPositions.Length] = lightProbeGroup.transform.InverseTransformPoint(newPosition);
                    lightProbeGroup.probePositions = newPositions;
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
