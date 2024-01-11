using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Utils : MonoBehaviour
{
    public static List<Type> ALLOWED_KIT_TYPES = new List<Type>()
    {
        typeof(GameObject),
        typeof(Material),
        typeof(Shader)
    };

}

public enum BanterBuilderBundleMode
{
    None = 0,
    Scene = 1,
    Kit = 2    
}
public class KitObjectAndPath
{
    public UnityEngine.Object obj;
    public string path;
}