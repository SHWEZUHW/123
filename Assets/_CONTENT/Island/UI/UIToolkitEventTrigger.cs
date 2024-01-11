using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UIElements;
using System.Collections;

public class UIToolkitEventTrigger : MonoBehaviour
{
    // Button
    public string buttonName; // Name of the button in the UXML
    public UnityEvent onButtonClicked; // UnityEvent to trigger for button

    // Toggle
    public string toggleName; // Name of the toggle in the UXML
    public UnityEvent<bool> onToggleValueChanged; // UnityEvent to trigger for toggle

    // Slider
    public string sliderName; // Name of the slider in the UXML
    public UnityEvent<float> onSliderValueChanged; // UnityEvent to trigger for slider

    private void OnEnable()
    {
        StartCoroutine(AddUIElementCallbacks());
    }

    private void OnDisable()
    {
        var root = GetComponent<UIDocument>().rootVisualElement;
        UnregisterButton(root);
        UnregisterToggle(root);
        UnregisterSlider(root);
    }

    private IEnumerator AddUIElementCallbacks()
    {
        yield return new WaitForEndOfFrame();
        var root = GetComponent<UIDocument>().rootVisualElement;

        RegisterButton(root);
        RegisterToggle(root);
        RegisterSlider(root);
    }

    private void RegisterButton(VisualElement root)
    {
        var button = root.Q<Button>(buttonName);
        if (button != null)
        {
            button.clicked += OnButtonClicked;
        }
        else
        {
            Debug.LogWarning("Button not found: " + buttonName);
        }
    }

    private void RegisterToggle(VisualElement root)
    {
        var toggle = root.Q<Toggle>(toggleName);
        if (toggle != null)
        {
            toggle.RegisterValueChangedCallback(evt => onToggleValueChanged.Invoke(evt.newValue));
        }
        else
        {
            Debug.LogWarning("Toggle not found: " + toggleName);
        }
    }

    private void RegisterSlider(VisualElement root)
    {
        var slider = root.Q<Slider>(sliderName);
        if (slider != null)
        {
            slider.RegisterValueChangedCallback(evt => onSliderValueChanged.Invoke(evt.newValue));
        }
        else
        {
            Debug.LogWarning("Slider not found: " + sliderName);
        }
    }

    private void UnregisterButton(VisualElement root)
    {
        var button = root.Q<Button>(buttonName);
        if (button != null)
        {
            button.clicked -= OnButtonClicked;
        }
    }

    private void UnregisterToggle(VisualElement root)
    {
        var toggle = root.Q<Toggle>(toggleName);
        if (toggle != null)
        {
            toggle.UnregisterValueChangedCallback(evt => onToggleValueChanged.Invoke(evt.newValue));
        }
    }

    private void UnregisterSlider(VisualElement root)
    {
        var slider = root.Q<Slider>(sliderName);
        if (slider != null)
        {
            slider.UnregisterValueChangedCallback(evt => onSliderValueChanged.Invoke(evt.newValue));
        }
    }

    private void OnButtonClicked()
    {
        onButtonClicked.Invoke();
    }
}
