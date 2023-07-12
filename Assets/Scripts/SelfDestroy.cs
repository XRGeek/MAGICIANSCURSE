using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelfDestroy : MonoBehaviour
{
    [SerializeField]
    private float timer = 5f;

    private void Awake()
    {
        Destroy(gameObject, timer);
    }
}
