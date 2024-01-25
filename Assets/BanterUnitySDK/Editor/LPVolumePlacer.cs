using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class LPVolumePlacer : EditorWindow
{
    private GameObject meshObject;
    private LightProbeGroup assignedLightProbeGroup;
    private float probeSpacing = 1.0f;

    [MenuItem("Banter/Tools/LP Volume Placer")]
    public static void ShowWindow()
    {
        GetWindow(typeof(LPVolumePlacer), true, "LP Volume Placer");
    }

    void OnGUI()
    {
        GUILayout.Label("Base Settings", EditorStyles.boldLabel);
        meshObject = (GameObject)EditorGUILayout.ObjectField("Mesh Object", meshObject, typeof(GameObject), true);
        assignedLightProbeGroup = (LightProbeGroup)EditorGUILayout.ObjectField("Light Probe Group", assignedLightProbeGroup, typeof(LightProbeGroup), true);
        probeSpacing = EditorGUILayout.FloatField("Probe Spacing", probeSpacing);

        if (meshObject != null)
        {
            Bounds bounds = new Bounds(meshObject.transform.position, Vector3.Scale(meshObject.transform.localScale, meshObject.GetComponent<MeshFilter>().sharedMesh.bounds.size));
            int estimatedProbes = CalculateEstimatedProbes(bounds, probeSpacing);
            EditorGUILayout.LabelField("Estimated Number of Probes: " + estimatedProbes);
        }

        if (GUILayout.Button("Place Light Probes"))
        {
            PlaceProbes();
        }
    }

    int CalculateEstimatedProbes(Bounds bounds, float spacing)
    {
        int countX = Mathf.FloorToInt(bounds.size.x / spacing);
        int countY = Mathf.FloorToInt(bounds.size.y / spacing);
        int countZ = Mathf.FloorToInt(bounds.size.z / spacing);
        return (countX + 1) * (countY + 1) * (countZ + 1);
    }

    void PlaceProbes()
    {
        if (meshObject == null)
        {
            Debug.LogError("Mesh Object is not set.");
            return;
        }

        if (assignedLightProbeGroup == null)
        {
            assignedLightProbeGroup = meshObject.GetComponent<LightProbeGroup>();
            if (assignedLightProbeGroup == null)
            {
                assignedLightProbeGroup = meshObject.AddComponent<LightProbeGroup>();
            }
        }

        MeshFilter meshFilter = meshObject.GetComponent<MeshFilter>();
        if (meshFilter == null)
        {
            Debug.LogError("MeshFilter component not found.");
            return;
        }

        Bounds bounds = new Bounds(meshObject.transform.position, Vector3.Scale(meshObject.transform.localScale, meshFilter.sharedMesh.bounds.size));
        Vector3 min = bounds.min;
        Vector3 max = bounds.max;

        var probePositions = new List<Vector3>();
        for (float x = min.x; x <= max.x; x += probeSpacing)
        {
            for (float y = min.y; y <= max.y; y += probeSpacing)
            {
                for (float z = min.z; z <= max.z; z += probeSpacing)
                {
                    Vector3 probePosition = new Vector3(x, y, z);
                    if (IsPointInsideCollider(probePosition, meshObject))
                    {
                        probePositions.Add(probePosition);
                    }
                }
            }
        }

        assignedLightProbeGroup.probePositions = probePositions.ToArray();
        Debug.Log($"Placed {probePositions.Count} probes.");
    }

    bool IsPointInsideCollider(Vector3 point, GameObject obj)
    {
        Collider collider = obj.GetComponent<Collider>();
        if (collider == null)
        {
            Debug.LogWarning("No Collider component found on the object, cannot verify if the point is inside the mesh.");
            return false;
        }
        return collider.bounds.Contains(point);
    }
}

