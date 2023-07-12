using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Security.Cryptography;
using UnityEngine;

public class SelfRotation : MonoBehaviour
{
    [SerializeField]
    float rotateSpeed = 1f;
    [SerializeField]
    float Xrot = 0f;
    [SerializeField]
    float Yrot = 0f;
    [SerializeField]
    float Zrot = 0f;

    private Vector3 rotation;
    
    public bool stopRotation = false;
    public bool resetRotation = false;
    [SerializeField]
    private Transform targetResetRotation;
    [SerializeField]
    float lerpDuration = 3.0f;
    [SerializeField]
    float timeElapsed = 0.0f;
    [SerializeField]
    private float resetSpeed = 10.0f;

    private void Start()
    {
        rotation = new Vector3(Xrot, Yrot, Zrot);
    }


    void Update()
    {
        if (stopRotation)
            return;
        if(resetRotation)
        {
            if (timeElapsed < lerpDuration)
            {
                transform.position = Vector3.Lerp(transform.position, targetResetRotation.position, resetSpeed * Time.deltaTime / lerpDuration);
                transform.rotation = Quaternion.Lerp(transform.rotation, targetResetRotation.rotation, resetSpeed * Time.deltaTime / lerpDuration);
                timeElapsed += Time.deltaTime;
            }
            else
            {
                transform.position = targetResetRotation.position;
                transform.rotation = targetResetRotation.rotation;
                resetRotation = false;
                stopRotation = true;
                return;
            }
        }
        transform.Rotate(rotation, rotateSpeed * Time.deltaTime, Space.Self);

    }
}
