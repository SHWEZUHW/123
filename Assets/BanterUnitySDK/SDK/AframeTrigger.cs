using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AframeTrigger : MonoBehaviour
{
    [HideInInspector]
    public bool isLocal;

    private TriggerEvent triggerEvent;

    private PlayerTriggerEvent playerTriggerEvent;

    private ButtonTriggerSync buttonTriggerSync;

    private KeyboardTrigger keyboardTrigger;

    void Start() {
        triggerEvent = GetComponent<TriggerEvent>();
        playerTriggerEvent = GetComponent<PlayerTriggerEvent>();
        buttonTriggerSync = GetComponent<ButtonTriggerSync>();
        keyboardTrigger = GetComponent<KeyboardTrigger>();
    }
    public void Send(string message) {
#if BANTER_EDITOR   
        var aframeTrigger = new GenericMessage();
        aframeTrigger.type = "AframeTrigger";
        aframeTrigger.msg = message;
        if(triggerEvent != null) {
            aframeTrigger.id = triggerEvent.isLocal ? 1 : 0;
        }else if(playerTriggerEvent != null) {
            aframeTrigger.id = playerTriggerEvent.isLocal ? 1 : 0;
        }else if(buttonTriggerSync != null) {
            aframeTrigger.id = buttonTriggerSync.isLocal ? 1 : 0;
        }else if(keyboardTrigger != null) {
            aframeTrigger.id = keyboardTrigger.isLocal ? 1 : 0;
        }
        Utils.SendToAframe(JsonUtility.ToJson(aframeTrigger));
#endif
    }
}
