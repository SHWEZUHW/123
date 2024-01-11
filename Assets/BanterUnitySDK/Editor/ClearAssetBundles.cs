using System;
using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System.IO;
using System.Reflection;

public class ClearAssetBundles : EditorWindow
{
    [MenuItem("Banter/Tools/Clear All Asset Bundles")]
    public static void ClearAllAssetBundles()
    {
        // Fetch all asset paths in the project
        string[] allAssetPaths = AssetDatabase.GetAllAssetPaths();

        // Initialize a list to hold asset bundle names
        List<string> assetBundleNames = new List<string>();

        // Iterate through all asset paths and find asset bundles
        foreach (string path in allAssetPaths)
        {
            string assetBundleName = AssetImporter.GetAtPath(path).assetBundleName;
            if (!string.IsNullOrEmpty(assetBundleName))
            {
                assetBundleNames.Add(assetBundleName);
            }
        }

        // Remove all asset bundles
        AssetBundle.UnloadAllAssetBundles(true);


        // Clear the AssetBundle cache (using reflection to call it in the editor)
        MethodInfo clearCacheMethod = typeof(Caching).GetMethod(
            "ClearCache", 
            BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic, 
            null, 
            new Type[0], 
            null
        );

        if (clearCacheMethod != null)
        {
            bool success = (bool)clearCacheMethod.Invoke(null, null);
            if (!success)
            {
                Debug.LogError("Failed to clear the AssetBundle cache.");
            }
        }
        else
        {
            Debug.LogError("Could not find the ClearCache method.");
        }

        // Refresh and update the asset database
        AssetDatabase.Refresh();

        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        Debug.Log("Cleared all asset bundles.");
    }
}
