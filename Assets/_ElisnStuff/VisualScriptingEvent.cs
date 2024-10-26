using UnityEngine;
using UnityEngine.Events;

public class VisualScriptingEvent : MonoBehaviour
{
    public UnityEvent OnCustomEvent;

    public void TriggerEvent()
    {
        OnCustomEvent?.Invoke();
    }
}
