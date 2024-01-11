using UnityEngine;

public class ColorSetter : MonoBehaviour
{
    // You can set this color in the Unity Editor or via another script
    public Color newColor = Color.white;

    void Start()
    {
        // Get the Renderer component from the GameObject where this script is attached
        Renderer renderer = GetComponent<Renderer>();

        // Check if the renderer and the material are not null
        if (renderer != null && renderer.material != null)
        {
            // Set the _Color property
            renderer.material.SetColor("_Color", newColor);
        }
        else
        {
            Debug.LogError("Renderer or Material is missing on the GameObject.");
        }
    }
}
