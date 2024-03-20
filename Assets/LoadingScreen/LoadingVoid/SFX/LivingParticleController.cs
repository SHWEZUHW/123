using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LivingParticleController : MonoBehaviour
{
    public Transform affector;
    public Material material;

    void Start()
    {
        //material = GetComponent<Renderer>().material;
    }

    void Update()
    {

      material.SetVector("_Affector", affector.position);
    }
}
