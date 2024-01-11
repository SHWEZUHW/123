using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveObjectToTransform : MonoBehaviour {
	
	 [Header("Set Object transforms with events or:")]
    [Tooltip("Enable to move the object using smooth interpolation.")]
    public bool isLerped;

    [Tooltip("Enable to move the object using Rigidbody physics.")]
    public bool isRigidBody;

    [Tooltip("Time in seconds to complete the position lerp.")]
    public float lerpTime = 1;

    [Tooltip("Time in seconds to complete the rotation lerp.")]
    public float rotateLerpTime = 1;

    [Tooltip("The target Transform to which the object will move.")]
    public Transform targetObject;

    [Tooltip("The target scale the object will reach.")]
    public Vector3 targetScale = Vector3.one;
    private float startedPosTime = -1;
    private float startedRotTime = -1;
    private Vector3 targetPos;
    private Quaternion targetRot;
    private Vector3 initialPos;
    private Quaternion initialRot;
    private Rigidbody body;
	
	// Function to set local position
	public void SetLocalPositionX(float x)
	{
		Vector3 newPosition = transform.localPosition;
		newPosition.x = x;
		transform.localPosition = newPosition;
	}

	public void SetLocalPositionY(float y)
	{
		Vector3 newPosition = transform.localPosition;
		newPosition.y = y;
		transform.localPosition = newPosition;
	}

	public void SetLocalPositionZ(float z)
	{
		Vector3 newPosition = transform.localPosition;
		newPosition.z = z;
		transform.localPosition = newPosition;
	}


    // Function to set local rotation
	public void SetLocalRotationX(float x)
	{
		Vector3 newRotation = transform.localEulerAngles;
		newRotation.x = x;
		transform.localEulerAngles = newRotation;
	}

	public void SetLocalRotationY(float y)
	{
		Vector3 newRotation = transform.localEulerAngles;
		newRotation.y = y;
		transform.localEulerAngles = newRotation;
	}

	public void SetLocalRotationZ(float z)
	{
		Vector3 newRotation = transform.localEulerAngles;
		newRotation.z = z;
		transform.localEulerAngles = newRotation;
	}


    // Function to set scale
    public void SetScaleX(float x)
    {
        Vector3 newScale = transform.localScale;
        newScale.x = x;
        transform.localScale = newScale;
    }

    public void SetScaleY(float y)
    {
        Vector3 newScale = transform.localScale;
        newScale.y = y;
        transform.localScale = newScale;
    }

    public void SetScaleZ(float z)
    {
        Vector3 newScale = transform.localScale;
        newScale.z = z;
        transform.localScale = newScale;
    }

    // Function for uniform scale
    public void SetUniformScale(float scale)
    {
        transform.localScale = new Vector3(scale, scale, scale);
    }
	
    public void SetObjectPosition(Transform _targetObject) {
        if(isRigidBody && body == null) {
            body = GetComponent<Rigidbody>();
        }
        if(isLerped) {
            targetPos = this.targetObject != null ? this.targetObject.position : _targetObject.position;
            initialPos = transform.position;
            startedPosTime = Time.fixedUnscaledTime;
        }else{
            if(isRigidBody && body != null) {
                body.position = this.targetObject != null ? this.targetObject.position : _targetObject.position;
            }else{
                transform.position = this.targetObject != null ? this.targetObject.position : _targetObject.position;
            }
        }
    }

    public void SetObjectRotation(Transform _targetObject) {
        if(isRigidBody && body == null) {
            body = GetComponent<Rigidbody>();
        }
        if(isLerped) {
            targetRot = this.targetObject != null ? this.targetObject.rotation : _targetObject.rotation;
            initialRot = transform.rotation;
            startedRotTime = Time.fixedUnscaledTime;
        }else{
            if(isRigidBody && body != null) {
                body.rotation = this.targetObject != null ? this.targetObject.rotation : _targetObject.rotation;
            }else{
                transform.rotation = this.targetObject != null ? this.targetObject.rotation : _targetObject.rotation;
            }
        }
    }

    public void SetObjectPositionAndRotation(Transform targetObject) {
        SetObjectPosition(targetObject);
        SetObjectRotation(targetObject);
    }

    void FixedUpdate() {
        var timePos = Time.fixedUnscaledTime - startedPosTime;
        var timeRot = Time.fixedUnscaledTime - startedRotTime;
        if(isLerped) {
            if(startedPosTime > -1) {
                var pos = Vector3.Lerp(initialPos, targetPos, timePos / lerpTime);
                if(isRigidBody && body != null) {
                    body.position = pos;
                }else{
                    transform.position = pos;
                }
            }
            if(startedRotTime > -1) {
                var rot = Quaternion.Slerp(initialRot, targetRot, timeRot / rotateLerpTime);
                if(isRigidBody && body != null) {
                    body.rotation = rot;
                }else{
                    transform.rotation = rot;
                }
            }
            if(timePos > lerpTime && startedPosTime > -1) {
                startedPosTime = -1;
            }
            if(timeRot > rotateLerpTime && startedRotTime > -1) {
                startedRotTime = -1;
            }
        }
    }
}