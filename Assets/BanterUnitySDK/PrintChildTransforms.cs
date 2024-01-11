using UnityEngine;
using System.Collections.Generic;

public class PrintChildTransforms : MonoBehaviour
{
    private void Start()
    {
        List<string> results = new List<string>();

        foreach (Transform child in transform)
        {
            Vector3 position = child.position;
            Vector3 rotation = child.eulerAngles;

            // Invert the z value of the position
            position.z = -position.z;

            // Invert the x and y values of the rotation
            rotation.x = -rotation.x;
            rotation.y = -rotation.y;

            // Round the position and rotation values to 2 decimal places
            position = new Vector3((float)System.Math.Round(position.x, 2), (float)System.Math.Round(position.y, 2), (float)System.Math.Round(position.z, 2));
            rotation = new Vector3((float)System.Math.Round(rotation.x, 2), (float)System.Math.Round(rotation.y, 2), (float)System.Math.Round(rotation.z, 2));

            string title = "Title";
            string href = "Link";

            string template = "<a-link rotation=\"{0} {1} {2}\" position=\"{3} {4} {5}\" title=\"{6}\" href=\"{7}\"></a-link>";
            string result = string.Format(template, rotation.x, rotation.y, rotation.z, position.x, position.y, position.z, title, href);

            results.Add(result);
        }

        // Log all of the results at once
        string output = string.Join("\n", results.ToArray());
        Debug.Log(output);
    }
}
