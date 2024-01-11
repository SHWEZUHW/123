using System;
using System.IO;
using UnityEngine;

public class Capture360Controller : MonoBehaviour
{
    public int width = 1024;
    public Camera renderCam;
    public bool faceCameraDirection = true;
    public float eyeSeparation = 62f; // 62mm (we will convert this to meters in the script)
    public bool swapImages = false;
    public bool is360 = false;
    public bool isTopBottom = false;

    public void SetSwapImages(bool swapImages)
    {
        this.swapImages = swapImages;
    }
    public void SetEyeSeperation(float eyeSeparation)
    {
        this.eyeSeparation = eyeSeparation;
    }

    public void SetIsTopBottom(bool isTopBottom)
    {
        this.isTopBottom = isTopBottom;
    }

    public void SetIs360(bool is360)
    {
        this.is360 = is360;
    }
    public void SetFaceDirection(bool faceCameraDirection)
    {
        this.faceCameraDirection = faceCameraDirection;
    }
    public void SetRenderCam(Camera renderCam)
    {
        this.renderCam = renderCam;
    }

    public void SetWidth(int width)
    {
        this.width = width;
    }

    public void Capture()
    {
        // If renderCam is not assigned, use the main camera
        if (renderCam == null)
        {
            renderCam = Camera.main;
        }

        // Save the original position of the camera
        Vector3 originalPosition = renderCam.transform.position;
        float eyeSeparationMeters = eyeSeparation / 1000; // convert mm to meters

        // Move the camera to the left eye position and capture the left eye image
        renderCam.transform.position = originalPosition + new Vector3(-eyeSeparationMeters / 2, 0, 0);
        byte[] capturedImageLeftBytes = I360Render.Capture(width, true, renderCam, faceCameraDirection);
        
        Texture2D capturedImageLeft = LoadTexture(capturedImageLeftBytes);

        // Move the camera to the right eye position and capture the right eye image
        renderCam.transform.position = originalPosition + new Vector3(eyeSeparationMeters / 2, 0, 0);
        byte[] capturedImageRightBytes = I360Render.Capture(width, true, renderCam, faceCameraDirection);
        
        Texture2D capturedImageRight = LoadTexture(capturedImageRightBytes);

        // Restore the original position of the camera
        renderCam.transform.position = originalPosition;

        // Swap images if needed
        if (swapImages)
        {
            Texture2D temp = capturedImageLeft;
            capturedImageLeft = capturedImageRight;
            capturedImageRight = temp;
        }

        // Crop and merge images if not 360, otherwise just merge
        Texture2D result;
        if (is360)
        {
            result = isTopBottom ? MergeImagesTopBottom(capturedImageLeft, capturedImageRight) : MergeImages(capturedImageLeft, capturedImageRight);
        }
        else
        {
            Texture2D croppedLeft = CropImage(capturedImageLeft);
            Texture2D croppedRight = CropImage(capturedImageRight);
            result = isTopBottom ? MergeImagesTopBottom(croppedLeft, croppedRight) : MergeImages(croppedLeft, croppedRight);
        }
        string dir = Path.Combine(Application.persistentDataPath, "Photos");
        if (!Directory.Exists(dir)){
            Directory.CreateDirectory(dir);
        }
#if BANTER_EDITOR 
        Utils.SaveTextureToFile(result, Path.Join(dir, $"{DateTime.Now:yyyy-MM-dd}_{DateTime.Now:HH-mm-ss}_" + (DateTime.Now - DateTime.UnixEpoch).TotalMilliseconds + ".jpg"));
#endif
    }

    Texture2D LoadTexture(byte[] imageData)
    {
        Texture2D tex = new Texture2D(2, 2);
        tex.LoadImage(imageData);
        return tex;
    }

    Texture2D CropImage(Texture2D original)
    {
        int width = original.width;
        int height = original.height;
        int newWidth = width / 2; // 50% width after cropping 25% from both sides

        Texture2D cropped = new Texture2D(newWidth, height);

        Color[] pixels = original.GetPixels(width / 4, 0, newWidth, height);
        cropped.SetPixels(pixels);
        cropped.Apply();

        return cropped;
    }

    Texture2D MergeImages(Texture2D image1, Texture2D image2)
    {
        if (image1.height != image2.height)
        {
            Debug.LogError("Images do not have the same height. Cannot merge.");
            return null;
        }

        int width = image1.width + image2.width;
        int height = image1.height;

        Texture2D merged = new Texture2D(width, height);

        Color[] pixels1 = image1.GetPixels();
        Color[] pixels2 = image2.GetPixels();

        merged.SetPixels(0, 0, image1.width, height, pixels1);
        merged.SetPixels(image1.width, 0, image2.width, height, pixels2);
        merged.Apply();

        return merged;
    }

    Texture2D MergeImagesTopBottom(Texture2D imageTop, Texture2D imageBottom)
    {
        int width = Mathf.Max(imageTop.width, imageBottom.width);
        int height = imageTop.height + imageBottom.height;
        Texture2D result = new Texture2D(width, height, TextureFormat.RGBA32, false);

        for (int i = 0; i < imageTop.width; i++)
        {
            for (int j = 0; j < imageTop.height; j++)
            {
                result.SetPixel(i, j + imageBottom.height, imageTop.GetPixel(i, j));
            }
        }

        for (int i = 0; i < imageBottom.width; i++)
        {
            for (int j = 0; j < imageBottom.height; j++)
            {
                result.SetPixel(i, j, imageBottom.GetPixel(i, j));
            }
        }

        result.Apply();
        return result;
    }
}