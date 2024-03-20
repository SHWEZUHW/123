using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectorPositionsToMaterial : MonoBehaviour {

    public Transform[] affectors; // The array of effector objects
    private Vector4[] positions; // To hold positions of affectors
    private Renderer renderer; // Renderer to which the material is attached

	void Start () {
        // Initialize the renderer component
        renderer = GetComponent<Renderer>();
        // Initialize the positions array with a maximum expected size, adjust as necessary
        Vector4[] maxArray = new Vector4[20];
        // Set the initial vector array to the material
        renderer.material.SetVectorArray("_Affectors", maxArray);
    }

    // Sending an array of positions to the shader
    void Update () {
        // Ensure we have affectors to process
        if(affectors != null && affectors.Length > 0) {
            positions = new Vector4[affectors.Length];
            for (int i = 0; i < positions.Length; i++)
            {
                // Assign the position of each effector to the array
                positions[i] = affectors[i].position;
            }
            // Update the material with the current positions of affectors
            renderer.material.SetVectorArray("_Affectors", positions);
            // Update the count of affectors in the shader
            renderer.material.SetInt("_AffectorCount", affectors.Length);
        }
    }
}
