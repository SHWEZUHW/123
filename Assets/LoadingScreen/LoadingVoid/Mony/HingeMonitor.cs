using UnityEngine;
using UnityEngine.Events;
using System.Collections.Generic;

public class HingeMonitor : MonoBehaviour
{
    public UnityEvent onHingeBreak;

    private List<HingeJoint> hinges;

    private void Start()
    {
        // Get all HingeJoints in this GameObject and its children
        hinges = new List<HingeJoint>(GetComponentsInChildren<HingeJoint>());
    }

    private void Update()
    {
        // Create a copy of the list to iterate through it while potentially removing items
        List<HingeJoint> hingesCopy = new List<HingeJoint>(hinges);

        foreach (var hinge in hingesCopy)
        {
            if (hinge == null)
            {
                hinges.Remove(hinge);
                onHingeBreak.Invoke();
            }
        }
    }
}
