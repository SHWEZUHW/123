using System;
using UnityEditor;
using UnityEngine;
using System.Collections.Generic;

public class ClearAssetBundles : EditorWindow
{
    [MenuItem("Banter/Tools/Clear All Asset Bundles")]
    public static void ClearAllAssetBundles()
    {
        // Fetch all asset paths in the project
        string[] allAssetPaths = AssetDatabase.GetAllAssetPaths();

        // Iterate through all asset paths and clear asset bundle names
        foreach (string path in allAssetPaths)
        {
            AssetImporter assetImporter = AssetImporter.GetAtPath(path);
            if (assetImporter != null && !string.IsNullOrEmpty(assetImporter.assetBundleName))
            {
                assetImporter.assetBundleName = string.Empty;
            }
        }

        // Clear the AssetBundle cache
        if (!Caching.ClearCache())
        {
            Debug.LogError("Failed to clear the AssetBundle cache.");
        }

        // Refresh and update the asset database
        AssetDatabase.Refresh();

        // Remove unused asset bundle names
        AssetDatabase.RemoveUnusedAssetBundleNames();
        AssetDatabase.Refresh();
        
        Debug.Log("Cleared all asset bundles.");
    }
}
