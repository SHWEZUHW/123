using System;
using UnityEngine;

public enum CameraMode { Normal, Mode_180, Mode_360 }
public enum ResolutionPreset { Res_1K, Res_3K, Res_6K, Res_8K }

public class EnhancedCaptureController : MonoBehaviour
{
    public CameraMode cameraMode = CameraMode.Normal;
    public ResolutionPreset resolutionPreset = ResolutionPreset.Res_1K;
    public Camera renderCam;

    // Parameters for normal mode
    public float zoomFOV = 60f; // Default Field of View for Normal mode

    // 3D and Top-Bottom Toggle
    public bool is3DEnabled = false;
    public bool isTopBottom = false;

    // Custom Resolution
    public int customWidth = 1024;
    public int customHeight = 768;

    void Start()
    {
        // Initial setup and configuration based on selected options
        UpdateCameraSettings();
    }
	
	// Public functions to set properties via Unity events
    public void SetCameraMode(CameraMode mode)
    {
        cameraMode = mode;
        UpdateCameraSettings();
    }

    public void SetResolutionPreset(ResolutionPreset preset)
    {
        resolutionPreset = preset;
        UpdateCameraSettings();
    }

    public void SetZoomFOV(float fov)
    {
        zoomFOV = fov;
        if (cameraMode == CameraMode.Normal)
        {
            SetupNormalCamera();
        }
    }

    public void SetIs3DEnabled(bool enabled)
    {
        is3DEnabled = enabled;
        // Additional logic for enabling/disabling 3D
    }

    public void SetIsTopBottom(bool topBottom)
    {
        isTopBottom = topBottom;
        // Additional logic for top-bottom 3D configuration
    }

    public void SetCustomWidth(int width)
    {
        customWidth = width;
        SetResolution(customWidth, customHeight);
    }

    public void SetCustomHeight(int height)
    {
        customHeight = height;
        SetResolution(customWidth, customHeight);
    }



    private void UpdateCameraSettings()
    {
        // Update camera mode
        switch (cameraMode)
        {
            case CameraMode.Normal:
                SetupNormalCamera();
                break;
            case CameraMode.Mode_180:
                Setup180Camera();
                break;
            case CameraMode.Mode_360:
                Setup360Camera();
                break;
        }

        // Update resolution
        switch (resolutionPreset)
        {
            case ResolutionPreset.Res_1K:
                SetResolution(1024, 768);
                break;
            case ResolutionPreset.Res_3K:
                SetResolution(3000, 2000);
                break;
            case ResolutionPreset.Res_6K:
                SetResolution(6000, 4000);
                break;
            case ResolutionPreset.Res_8K:
                SetResolution(8000, 6000);
                break;
        }
    }

    private void SetupNormalCamera()
    {
        renderCam.fieldOfView = zoomFOV;
        // Additional configuration for normal camera mode
    }

    private void Setup180Camera()
    {
        // Configuration for 180-degree camera mode
    }

    private void Setup360Camera()
    {
        // Configuration for 360-degree camera mode
    }

    private void SetResolution(int width, int height)
    {
        // Set the resolution of the camera
        renderCam.pixelRect = new Rect(0, 0, width, height);
    }

    // Additional methods to handle 3D settings, custom resolutions, etc.
}
