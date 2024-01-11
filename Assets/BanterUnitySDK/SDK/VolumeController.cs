using UnityEngine;
using System.Collections.Generic;

public class VolumeController : MonoBehaviour
{
	[SerializeField]
    private float volumeControl = 1f; // Serialized field
	
    public List<GameObject> audioObjects = new List<GameObject>();
    private Dictionary<AudioSource, float> originalVolumes = new Dictionary<AudioSource, float>();



    public float VolumeControl
    {
        get { return volumeControl; }
        set
        {
            volumeControl = Mathf.Clamp(value, 0f, 1f); // Clamps the value between 0 and 1
            UpdateAudioSourcesVolume(volumeControl);
        }
    }

    void Start()
    {
        // Store the original volumes of all audio sources and update their volumes
        foreach (GameObject obj in audioObjects)
        {
            AudioSource audioSource = obj.GetComponent<AudioSource>();
            if (audioSource != null)
            {
                originalVolumes[audioSource] = audioSource.volume;
            }
        }

        // Update the audio sources with the initial volume control value
        UpdateAudioSourcesVolume(volumeControl);
    }

    void UpdateAudioSourcesVolume(float volumeControl)
    {
        foreach (KeyValuePair<AudioSource, float> entry in originalVolumes)
        {
            if (entry.Key != null)
            {
                entry.Key.volume = entry.Value * volumeControl;
            }
        }
    }
}
