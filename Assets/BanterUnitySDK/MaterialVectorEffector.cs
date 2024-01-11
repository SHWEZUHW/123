using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialVectorEffector : MonoBehaviour
{
    public Transform affector;
    public Renderer targetRenderer; // Add a public field for the target Renderer

    void Update()
    {
        if (targetRenderer != null && affector != null)
        {
            // Set the _Affector vector on the target object's material
            targetRenderer.material.SetVector("_Affector", affector.position);
        }
    }
}
