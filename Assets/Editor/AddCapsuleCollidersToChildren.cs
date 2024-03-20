using UnityEngine;
using UnityEditor;

public class AddCapsuleCollidersToNonTipChildren : ScriptableObject
{
    [MenuItem("Tools/Add Capsule Colliders To Non-Tip Children")]
    static void AddCapsuleCollidersToNonTipChildrenMethod()
    {
        GameObject selectedObject = Selection.activeGameObject;

        if (selectedObject == null)
        {
            Debug.LogWarning("No object selected. Please select a parent object in the hierarchy.");
            return;
        }

        // Start the recursive addition from the selected object itself
        AddColliderToNonTipChildren(selectedObject.transform);

        Debug.Log("Capsule Colliders added to non-tip children of " + selectedObject.name);
    }

    static void AddColliderToNonTipChildren(Transform currentTransform)
    {
        // Recursive call to process all children
        foreach (Transform child in currentTransform)
        {
            AddColliderToNonTipChildren(child);
        }

        // If this transform has no children, it's a "tip" and should not get a collider.
        if (currentTransform.childCount == 0) return;

        // Now, we're sure the current object is not a tip. Let's add a collider if there's not already one.
        CapsuleCollider collider = currentTransform.gameObject.GetComponent<CapsuleCollider>();
        if (collider == null)
        {
            collider = currentTransform.gameObject.AddComponent<CapsuleCollider>();
        }

        collider.direction = 1; // Y axis as default direction

        // Calculate height based on distance to parent
        if (currentTransform.parent != null)
        {
            float distanceToParent = Vector3.Distance(currentTransform.position, currentTransform.parent.position);
            collider.height = Mathf.Max(distanceToParent, 0.1f); // Ensure there's a minimum height
            collider.radius = Mathf.Min(currentTransform.localScale.x, currentTransform.localScale.z) * 0.5f; // Set a proportional radius
            collider.center = new Vector3(0, collider.height * 0.5f, 0); // Adjust center based on the new height
        }
    }
}
