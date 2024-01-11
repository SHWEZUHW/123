using UnityEngine;

[System.Serializable]
public class ShaderProperty
{
    public string propertyName;
    public enum PropertyType { Texture, Color, Int, Float, Vector1, Vector2, Vector3, Vector4 }
    public PropertyType propertyType;

    // Values for different types
    public Texture textureValue;
    public Color colorValue;
    public int intValue;
    public float floatValue;
    public float vector1Value; // Vector1 is essentially a float
    public Vector2 vector2Value;
    public Vector3 vector3Value;
    public Vector4 vector4Value;
}

public class ShaderPropertyTrigger : MonoBehaviour
{
    public Renderer targetRenderer;
    public int materialIndex = 0;
    public ShaderProperty[] properties = new ShaderProperty[0]; // Initialize the array

    public void APPLY_Shader_Properties()
    {
        if (targetRenderer == null) 
        {
            Debug.LogError("Target Renderer is not set.");
            return;
        }

        if (materialIndex < 0 || materialIndex >= targetRenderer.materials.Length) 
        {
            Debug.LogError("Material index is out of range.");
            return;
        }

        Material targetMaterial = targetRenderer.materials[materialIndex];

        foreach (var prop in properties)
        {
            switch (prop.propertyType)
            {
                case ShaderProperty.PropertyType.Texture:
                    targetMaterial.SetTexture(prop.propertyName, prop.textureValue);
                    break;
                case ShaderProperty.PropertyType.Color:
                    targetMaterial.SetColor(prop.propertyName, prop.colorValue);
                    break;
                case ShaderProperty.PropertyType.Int:
                    targetMaterial.SetInt(prop.propertyName, prop.intValue);
                    break;
                case ShaderProperty.PropertyType.Float:
                    targetMaterial.SetFloat(prop.propertyName, prop.floatValue);
                    break;
                case ShaderProperty.PropertyType.Vector1:
                    targetMaterial.SetFloat(prop.propertyName, prop.vector1Value);
                    break;
                case ShaderProperty.PropertyType.Vector2:
                    targetMaterial.SetVector(prop.propertyName, new Vector4(prop.vector2Value.x, prop.vector2Value.y, 0, 0));
                    break;
                case ShaderProperty.PropertyType.Vector3:
                    targetMaterial.SetVector(prop.propertyName, prop.vector3Value);
                    break;
                case ShaderProperty.PropertyType.Vector4:
                    targetMaterial.SetVector(prop.propertyName, prop.vector4Value);
                    break;
            }
        }
    }
}