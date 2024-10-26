using UnityEngine;
using UnityEditor;
using System.IO;

public class NameTagBuilder
{
    [MenuItem("Banter/NameTag Builder")]
    static void BuildNameTagAssetBundle()
    {
        // Get the selected UXML file in the project
        string[] selectedAssets = Selection.assetGUIDs;
        if (selectedAssets.Length == 0)
        {
            Debug.LogError("Please select a UXML file in the Project window.");
            return;
        }

        string assetPath = AssetDatabase.GUIDToAssetPath(selectedAssets[0]);
        if (Path.GetExtension(assetPath) != ".uxml")
        {
            Debug.LogError("Selected file is not a UXML file.");
            return;
        }

        // Create AssetBundleBuild
        AssetBundleBuild[] buildMap = new AssetBundleBuild[1];
        buildMap[0].assetBundleName = "nametag.assetbundle";
        buildMap[0].assetNames = new string[] { assetPath };

        // Create the output directory if it doesn't exist
        string outputPath = "Assets/AssetBundles";
        if (!Directory.Exists(outputPath))
        {
            Directory.CreateDirectory(outputPath);
        }

        // Build the AssetBundle
        BuildPipeline.BuildAssetBundles(outputPath, buildMap, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows);

        Debug.Log("NameTag AssetBundle built successfully: " + Path.Combine(outputPath, buildMap[0].assetBundleName));
    }
}