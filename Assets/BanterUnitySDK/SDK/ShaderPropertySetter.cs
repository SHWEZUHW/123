using UnityEngine;

public class ShaderPropertySetter : MonoBehaviour
{
    // Shader property names and material index
        [Header("Shader Property Settings")]
    
    [SerializeField]
    [Tooltip("Optional: Assign a different MeshRenderer to use. If left empty, the MeshRenderer on the same GameObject will be used.")]
    public MeshRenderer optionalMeshRenderer;
[SerializeField]
    [Tooltip("The name of the shader property to modify. This is only used for properties set with their specific event and works only for texture, int, and float types.")]
    private string propertyName;

    [SerializeField]
    [Tooltip("The index of the material on this GameObject.")]
    private int materialIndex;

    [Header("Shader Properties to Apply")]
    [Tooltip("The name of the texture property in the shader.")]
    public string texturePropertyName;
    [Tooltip("The texture value to apply to the shader property.")]
    public Texture textureValue;

    [Tooltip("The name of the color property in the shader.")]
    public string colorPropertyName;
    [Tooltip("The color value to apply to the shader property.")]
    public Color colorValue;

    [Tooltip("The name of the integer property in the shader.")]
    public string intPropertyName;
    [Tooltip("The integer value to apply to the shader property.")]
    public int intValue;

    [Tooltip("The name of the float property in the shader.")]
    public string floatPropertyName;
    [Tooltip("The float value to apply to the shader property.")]
    public float floatValue;

    [Tooltip("The name of the Vector2 property in the shader.")]
    public string vector2PropertyName;
    [Tooltip("The Vector2 value to apply to the shader property.")]
    public Vector2 vector2Value;

    [Tooltip("The name of the Vector3 property in the shader.")]
    public string vector3PropertyName;
    [Tooltip("The Vector3 value to apply to the shader property.")]
    public Vector3 vector3Value;

    [Tooltip("The name of the Vector4 property in the shader.")]
    public string vector4PropertyName;
    [Tooltip("The Vector4 value to apply to the shader property.")]
    public Vector4 vector4Value;

    private Material material;

    void Start()
    {
        Renderer renderer = optionalMeshRenderer != null ? optionalMeshRenderer : GetComponent<Renderer>();
        if (renderer != null && renderer.materials.Length > materialIndex)
        {
            material = renderer.sharedMaterials[materialIndex];
        }
        else
        {
            Debug.LogError("Material index out of range or Renderer not found.");
        }
    }
	
	public void UpdateMaterialReference()
{
    Renderer renderer = optionalMeshRenderer != null ? optionalMeshRenderer : GetComponent<Renderer>();
    if (renderer != null && renderer.materials.Length > materialIndex)
    {
        material = renderer.materials[materialIndex];
    }
    else
    {
        Debug.LogError("Material index out of range or Renderer not found.");
        material = null; 
    }
}


 public void SetTexture(Texture textureValue)
    {
        if (material != null)
        {
            material.SetTexture(propertyName, textureValue);
        }
    }

    public void SetInt(int intValue)
    {
        if (material != null)
        {
            material.SetInt(propertyName, intValue);
        }
    }

    public void SetFloat(float floatValue)
    {
        if (material != null)
        {
            material.SetFloat(propertyName, floatValue);
        }
    }

    public void ApplyShaderProperties()
    {
        if (material == null) return;

        if (!string.IsNullOrEmpty(texturePropertyName) && textureValue != null)
        {
            material.SetTexture(texturePropertyName, textureValue);
        }

        if (!string.IsNullOrEmpty(colorPropertyName))
        {
            material.SetColor(colorPropertyName, colorValue);
        }

        if (!string.IsNullOrEmpty(intPropertyName))
        {
            material.SetInt(intPropertyName, intValue);
        }

        if (!string.IsNullOrEmpty(floatPropertyName))
        {
            material.SetFloat(floatPropertyName, floatValue);
        }

        if (!string.IsNullOrEmpty(vector2PropertyName))
        {
            material.SetVector(vector2PropertyName, vector2Value);
        }

        if (!string.IsNullOrEmpty(vector3PropertyName))
        {
            material.SetVector(vector3PropertyName, vector3Value);
        }

        if (!string.IsNullOrEmpty(vector4PropertyName))
        {
            material.SetVector(vector4PropertyName, vector4Value);
        }
    }
}
