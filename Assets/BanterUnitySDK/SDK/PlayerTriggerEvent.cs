using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(UniqueObjectId))]
public class PlayerTriggerEvent : MonoBehaviour
{
    public UnityEvent onGrabEvent;
    public UnityEvent onReleaseEvent;
    public UnityEvent onGrabLeftEvent;
    public UnityEvent onReleaseLeftEvent;
    public UnityEvent onGrabRightEvent;
    public UnityEvent onReleaseRightEvent;
    public UnityEvent onPointerClickEvent;
    
    [Tooltip("Whether this should be synced across the network")]
    public bool isSynced;
    public bool adminOnly;

    [HideInInspector]
    public bool isLocal;
#if BANTER_EDITOR 
    TriggerIndex index;
    void Start() {
        index = GameObject.FindGameObjectWithTag("TriggerIndex").GetComponent<TriggerIndex>();
        index?.AddPlayerTrigger(GetComponent<UniqueObjectId>().Id, this);
    }
    void OnDestroy() {
        index?.RemovePlayerTrigger(GetComponent<UniqueObjectId>().Id);
    }
#endif
    public void OnGrabLeft()
    {
#if BANTER_EDITOR 
        if(adminOnly && (index?.isAdmin??false) || !adminOnly) {
#endif
            isLocal = true;
            onGrabEvent?.Invoke();
            onGrabLeftEvent?.Invoke();
#if BANTER_EDITOR 
            if(isSynced){
                index?.SyncTriggerEvent("sq-grab-left", GetComponent<UniqueObjectId>().Id);
            }
        }
#endif
    }

    public void SetIsSynced(bool on)
    {
        isSynced = on;
    }

    public void SetAdminOnly(bool on)
    {
        adminOnly = on;
    }
    public void OnReleaseLeft()
    {
#if BANTER_EDITOR 
        if(adminOnly && (index?.isAdmin??false) || !adminOnly) {
#endif
            isLocal = true;
            onReleaseEvent?.Invoke();
            onReleaseLeftEvent?.Invoke();
#if BANTER_EDITOR 
            if(isSynced){
                index?.SyncTriggerEvent("sq-release-left", GetComponent<UniqueObjectId>().Id);
            }
        }
#endif
    }
    public void OnGrabRight()
    {
#if BANTER_EDITOR 
        if(adminOnly && (index?.isAdmin??false) || !adminOnly) {
#endif
            isLocal = true;
            onGrabEvent?.Invoke();
            onGrabRightEvent?.Invoke();
#if BANTER_EDITOR 
            if(isSynced){
                index?.SyncTriggerEvent("sq-grab-right", GetComponent<UniqueObjectId>().Id);
            }
        }
#endif
    }

    public void OnReleaseRight()
    {
#if BANTER_EDITOR 
        if(adminOnly && (index?.isAdmin??false) || !adminOnly) {
#endif
            isLocal = true;
            onReleaseEvent?.Invoke();
            onReleaseRightEvent?.Invoke();
#if BANTER_EDITOR 
            if(isSynced){
                index?.SyncTriggerEvent("sq-release-right", GetComponent<UniqueObjectId>().Id);
            }
        }
#endif
    }

    public void OnPointerClick()
    {
#if BANTER_EDITOR 
        if(adminOnly && (index?.isAdmin??false) || !adminOnly) {
#endif
            isLocal = true;
            onPointerClickEvent?.Invoke();
#if BANTER_EDITOR 
            if(isSynced){
                index?.SyncTriggerEvent("sq-pointer-click", GetComponent<UniqueObjectId>().Id);
            }
        }
#endif
    }
}
