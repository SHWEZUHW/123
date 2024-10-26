using UnityEngine;
using UnityEngine.Events;

public class ChangeAvatar : MonoBehaviour{

    public string HighUrl;
    public string LowUrl;
    public void SetAvatarUrl(string url){
#if BANTER_EDITOR 
        // Lets deprecate this
        // Utils.SetAvatarUrl(url);
#endif
    }
    public void SetAvatarUrls(){
#if BANTER_EDITOR 
        Utils.SetAvatarUrls(LowUrl, HighUrl);
#endif
    }
}