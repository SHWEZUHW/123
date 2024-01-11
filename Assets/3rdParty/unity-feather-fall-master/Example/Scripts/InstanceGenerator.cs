using System.Collections.Generic;
using UnityEngine;
using System.Collections;

public class InstanceGenerator : MonoBehaviour
{
    [SerializeField] private GameObject m_Prefab;
    [SerializeField, Range(0.1f, 10f)] private float m_GenerateDelay = 2;
    [SerializeField, Range(1f, 20f)] private float m_DestroyDelay = 10;
    [SerializeField] private bool m_RotateRandomly;
    [SerializeField] private float m_InitialVelocityMagnitude = 0; // The velocity magnitude
    private float m_LastTime;

    [SerializeField, Range(5, 50)] private int m_InitialPoolSize = 10; //Initial size of the object pool
    private List<GameObject> m_Pool;

    private void Start()
    {
        m_Pool = new List<GameObject>();
        for (int i = 0; i < m_InitialPoolSize; i++)
        {
            GameObject instance = Instantiate(m_Prefab);
            instance.SetActive(false);
            m_Pool.Add(instance);
        }
    }
    
    void OnDisable()
    {
        foreach (GameObject obj in m_Pool)
        {
            if (obj)
            {
                Destroy(obj);
            }
        }
        m_Pool = new List<GameObject>();
    }

    private void Update()
    {
        if (m_LastTime + m_GenerateDelay > Time.time)
        {
            return;
        }

        m_LastTime = Time.time;
        GameObject instance = GetPooledObject();

        if (instance != null)
        {
            instance.transform.position = transform.position;
            instance.transform.rotation = GetRotation();
            instance.SetActive(true);

            if (m_InitialVelocityMagnitude != 0)
            {
                Rigidbody rb = instance.GetComponent<Rigidbody>();
                if (rb)
                {
                    rb.velocity = transform.forward * m_InitialVelocityMagnitude; // Velocity in the forward direction
                }
            }

            // Requeue the object after the delay
            StartCoroutine(RequeueObject(instance, m_DestroyDelay));
        }
    }

    private GameObject GetPooledObject()
    {
        foreach (GameObject obj in m_Pool)
        {
            if (obj && !obj.activeInHierarchy)
            {
                return obj;
            }
        }

        // No inactive objects available. Expand pool
        GameObject newInstance = Instantiate(m_Prefab);
        newInstance.SetActive(false);
        m_Pool.Add(newInstance);
        return newInstance;
    }

    private IEnumerator RequeueObject(GameObject obj, float delay)
    {
        if (!obj)
            yield return null;
        
        yield return new WaitForSeconds(delay);
        obj.SetActive(false);
    }

    private Quaternion GetRotation()
    {
        return m_RotateRandomly ? Quaternion.Euler(Random.Range(0f, 360f), Random.Range(0f, 360f), Random.Range(0f, 360f)) : transform.rotation;
    }
}
