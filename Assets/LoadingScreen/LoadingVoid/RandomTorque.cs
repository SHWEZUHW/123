using UnityEngine;

public class RandomTorque : MonoBehaviour
{
    public float minTorque = 10f;
    public float maxTorque = 100f;

    void Start()
    {
        Rigidbody[] childRigidbodies = GetComponentsInChildren<Rigidbody>();

        foreach (Rigidbody childRigidbody in childRigidbodies)
        {
            Vector3 torque = Vector3.zero;
            torque.y = Random.Range(minTorque, maxTorque);
            childRigidbody.AddTorque(torque, ForceMode.Impulse);
        }
    }
}
