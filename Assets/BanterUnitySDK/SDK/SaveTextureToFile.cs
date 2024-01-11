

using System;
using System.IO;
using UnityEngine;
using UnityEngine.Events;

public class SaveTextureToFile : MonoBehaviour {
    Texture texture;
    [SerializeField]
    private UnityEvent done;
    public void Save(Texture texture) {
#if BANTER_EDITOR 
        this.texture = texture;
        Invoke("SaveTexture", 0.2f);
    }
    void SaveTexture() {
        string dir = Path.Combine(Application.persistentDataPath, "Photos");
        if (!Directory.Exists(dir)){
            Directory.CreateDirectory(dir);
        }
        Utils.SaveTextureToFile(texture, Path.Join(dir, $"{DateTime.Now:yyyy-MM-dd}_{DateTime.Now:HH-mm-ss}_" + (DateTime.Now - DateTime.UnixEpoch).TotalMilliseconds + ".jpg"));
        done?.Invoke();
#endif
    }
}