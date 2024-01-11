using UnityEngine;

public class SetSafetyNet : MonoBehaviour
{
    void Start()
    {
        // Find the SafetyNet object in the scene
        GameObject safetyNet = GameObject.Find("SafetyNet");

        if (safetyNet != null)
        {
            // Get the current object's Y position
            float newYPosition = transform.position.y;

            // Set the SafetyNet object's Y position to match the current object's Y position
            safetyNet.transform.position = new Vector3(safetyNet.transform.position.x, newYPosition, safetyNet.transform.position.z);
        }
        else
        {
            Debug.LogError("SafetyNet object not found in the scene.");
        }
    }
}
