using UnityEngine;
using UnityEngine.Events;
public class ChangeAvatar : MonoBehaviour{
    public void SetAvatarUrl(string url){
#if BANTER_EDITOR 
        Utils.SetAvatarUrl(url);
#endif
    }
}