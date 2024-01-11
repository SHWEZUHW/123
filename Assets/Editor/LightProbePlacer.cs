using UnityEngine;
using UnityEditor;
using UnityEngine.AI;
using System.Collections.Generic;

public class LightProbePlacer : EditorWindow
{
    private LightProbeGroup lightProbeGroup;
    private float gridDensity = 1f;
    private float mergeDistance = 1f;
    private float yOffset = 0.5f;

    [MenuItem("Window/Light Probe Placer on NavMesh")]
    public static void ShowWindow()
    {
        GetWindow<LightProbePlacer>("Light Probe Placer on NavMesh");
    }

    void OnGUI()
    {
        GUILayout.Label("Light Probe Placer Settings", EditorStyles.boldLabel);

        lightProbeGroup = (LightProbeGroup)EditorGUILayout.ObjectField("Light Probe Group", lightProbeGroup, typeof(LightProbeGroup), true);
        gridDensity = EditorGUILayout.FloatField("Grid Density", gridDensity);
        mergeDistance = EditorGUILayout.FloatField("Merge Distance", mergeDistance);
        yOffset = EditorGUILayout.FloatField("Y Offset", yOffset);

        if (GUILayout.Button("Place Light Probes"))
        {
            PlaceLightProbes();
        }

        if (GUILayout.Button("Merge Light Probes"))
        {
            MergeLightProbes();
        }

        NavMeshTriangulation navMeshData = NavMesh.CalculateTriangulation();

        if (navMeshData.vertices.Length > 0)
        {
            // Calculate NavMesh bounds
            Bounds navMeshBounds = new Bounds(navMeshData.vertices[0], Vector3.zero);
            foreach (Vector3 vertex in navMeshData.vertices)
            {
                navMeshBounds.Encapsulate(vertex);
            }

            // Calculate the estimated number of probes
            float totalArea = (navMeshBounds.max.x - navMeshBounds.min.x) * (navMeshBounds.max.z - navMeshBounds.min.z);
            int estimatedProbeCount = (int)(totalArea / (gridDensity * gridDensity)) + navMeshData.vertices.Length;

            GUILayout.Label("Estimated light probes to be placed: " + estimatedProbeCount);
        }
        else
        {
            GUILayout.Label("No NavMesh data found. Please bake your NavMesh.");
        }
    }

    void PlaceLightProbes()
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




    void MergeLightProbes()
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
}
