using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(UniqueObjectId))]
public class AframeEvent : MonoBehaviour
{
    [Tooltip("Event to call when trigger enters")]
    public UnityEvent onAframeEvent;
    [Tooltip("Event to call when trigger enters")]
    public UnityEvent onAframeEventOff;

    [Tooltip("Whether this should be synced across the network")]
    public bool isSynced;
    public bool adminOnly;

    [HideInInspector]
    public bool isLocal;
    [HideInInspector]
    public UniqueObjectId uniqueObjectId;
#if BANTER_EDITOR 
    TriggerIndex index;
    void Start() {
        uniqueObjectId = GetComponent<UniqueObjectId>();
        uniqueObjectId.Gen();
        index = GameObject.FindGameObjectWithTag("TriggerIndex").GetComponent<TriggerIndex>();
        index?.AddAframeTrigger(uniqueObjectId.Id, this);
    }
    void OnDestroy() {
        index?.RemoveTrigger(uniqueObjectId.Id);
    }
    void SetupEvent(string eventName) {
        if(isSynced){
            index?.SyncTriggerEvent("sq-aframe-event-" + eventName , uniqueObjectId.Id);
        }
        uniqueObjectId.lastObject = GameObject.FindGameObjectWithTag("PlayerHead").transform;
        isLocal = true;
    }
#endif
    public void OnAframeEventOn()
    {        
#if BANTER_EDITOR 
        if ((adminOnly && (index?.isAdmin??false) || !adminOnly)) {
            SetupEvent("on");
            onAframeEvent?.Invoke();
        }
#endif
    }

    public void OnAframeEventOff()
    {        
#if BANTER_EDITOR 
        if ((adminOnly && (index?.isAdmin??false) || !adminOnly)) {
            SetupEvent("off");
            onAframeEventOff?.Invoke();
        }
#endif
    }
}