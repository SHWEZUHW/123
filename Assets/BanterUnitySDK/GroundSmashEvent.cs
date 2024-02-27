using UnityEngine;
using UnityEngine.Events;

public class GroundSmashEvent : MonoBehaviour
{
    // UnityEvent to be triggered when the object smashes into the ground
    public UnityEvent OnSmash;

    // The minimum velocity required for the smash to be considered a "smash"
    // Adjust this value based on your game's requirements
    public float smashVelocityThreshold = -10f;

    private void OnCollisionEnter(Collision collision)
    {
        // Check if the impact velocity is strong enough to be considered a smash
        if (collision.relativeVelocity.y <= smashVelocityThreshold)
        {
            // Trigger the OnSmash UnityEvent
            OnSmash.Invoke();
        }
    }
}
