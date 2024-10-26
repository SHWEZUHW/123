using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;

[UnitTitle("Trigger Custom Event")]
[UnitCategory("Events")]
public class TriggerCustomEventNode : Unit
{
    [DoNotSerialize]
    [PortLabelHidden]
    public ValueInput targetGameObject;

    [DoNotSerialize]
    public ControlOutput triggered;

    [DoNotSerialize]
    public ControlInput trigger;

    protected override void Definition()
    {
        targetGameObject = ValueInput<GameObject>("VS Event");
        triggered = ControlOutput("");
        trigger = ControlInput("", TriggerEvent);

        Succession(trigger, triggered);
    }

    private ControlOutput TriggerEvent(Flow flow)
    {
        var target = flow.GetValue<GameObject>(targetGameObject);
        if (target != null)
        {
            var customEvent = target.GetComponent<VisualScriptingEvent>();
            if (customEvent != null)
            {
                customEvent.OnCustomEvent.Invoke();
            }
        }
        return triggered;
    }
}
