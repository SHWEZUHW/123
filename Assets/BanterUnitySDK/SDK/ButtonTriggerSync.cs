using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems; // For ExecuteEvents

[RequireComponent(typeof(UniqueObjectId))]
public class ButtonTriggerSync : MonoBehaviour
{
    Selectable selectable;
    public bool adminOnly;

    [HideInInspector]
    public bool isLocal;
#if BANTER_EDITOR
    TriggerIndex index;
    bool hasRecievedClick = false;

    void Start()
    {
        index = GameObject.FindGameObjectWithTag("TriggerIndex").GetComponent<TriggerIndex>();
        index?.AddButtonTrigger(GetComponent<UniqueObjectId>().Id, this);

        selectable = GetComponent<Selectable>();

        if (selectable is Button button) {
            button.onClick.AddListener(SendClick);
        } else if (selectable is Toggle toggle){
            toggle.onValueChanged.AddListener(delegate { SendClick(); });
        } else if (selectable is Slider slider) {
            slider.onValueChanged.AddListener(delegate { SendClick(slider.value); });
        }
    }

    void OnDestroy()
    {
        index?.RemoveButtonTrigger(GetComponent<UniqueObjectId>().Id);
    }
#endif
    public void SetAdminOnly(bool on)
    {
        adminOnly = on;
    }
    public void RemoteClickButton(string value = "")
    {
        isLocal = false;
        if (selectable is Button button) {
            button.onClick.RemoveListener(SendClick);
            button.OnSubmit(null);
            button.onClick.AddListener(SendClick);
        } else if (selectable is Toggle toggle) {
            toggle.onValueChanged.RemoveListener(delegate { SendClick(); });
            toggle.isOn = !toggle.isOn;
            toggle.onValueChanged.AddListener(delegate { SendClick(); });
        } else if (selectable is Slider slider) {
            slider.onValueChanged.RemoveListener(delegate { SendClick(); });
            slider.value = float.Parse(value);
            slider.onValueChanged.AddListener(delegate { SendClick(); });
        }
    }

    private void SendClick() {
        SendClick(0);
    }
    private void SendClick(float value = 0)
    {
#if BANTER_EDITOR
        if (adminOnly && (index?.isAdmin ?? false) || !adminOnly)
        {
            isLocal = true;
            index?.SyncTriggerEvent("sq-button-click", GetComponent<UniqueObjectId>().Id +(value > 0 ? ":|:" + value : "") );
        }
#endif
    }
}