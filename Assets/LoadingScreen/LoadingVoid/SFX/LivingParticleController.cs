using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LivingParticleController : MonoBehaviour
{

    public Transform affector;

    public ParticleSystemRenderer psr;
 
    // void Start()
    // {
    //     // psr = GetComponent<ParticleSystemRenderer>();
    //     // Search for an object named "LocoBall" in the scene and assign it to the "affector" variable
    //     // GameObject locoBall = GameObject.Find("LocoBall");
    //     // if (locoBall != null) {
    //     //     // affector = locoBall.transform;
            
    //     // }
    //     // else
    //     // {
    //     //     Debug.LogError("Unable to find an object named 'LocoBall' in the scene.");
    //     // }
    //     // SetAffectorPosition();
    // }

    void Update()
    {
        psr.material.SetVector("_Affector", affector.position);
    }

    // void SetAffectorPosition() {
        
    // }
}
