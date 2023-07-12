using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Security.Cryptography;
using UnityEngine;

public class GearTicks : MonoBehaviour
{
    [SerializeField]
    float delay;
    bool isDelayed = false;
    [SerializeField]
    float lerpDuration = 3.0f;
    [SerializeField]
    private float speed = 5.0f;
    float timeElapsed = 0.0f;

    private float newAngle;
    [SerializeField]
    private float startAngle = 0.0f;
    [SerializeField]
    private float rAngle = 5.0f;
    [SerializeField]
    private AudioClip[] turnSound;
    private AudioSource audioS;

    void Start()
    {
        audioS = GetComponent<AudioSource>();
        transform.localEulerAngles = new Vector3(0, 0, startAngle);
        newAngle = startAngle;
    }

    void Update()
    {
        if (isDelayed)
        {
            if (timeElapsed < delay)
            {
                timeElapsed += Time.deltaTime;
            }
            else if (timeElapsed >= delay)
            {
                audioS.clip = turnSound[Random.Range(0, turnSound.Length - 1)];
                audioS.volume = 0.25f;
                audioS.Play();
                isDelayed = false;
                timeElapsed = 0.0f;
                newAngle = newAngle + rAngle;
                Mathf.Round(newAngle * 100 / 100);
                if (newAngle >= 359.9f || newAngle <= -359.9f)
                    newAngle = 0;
            }
        }
        else
        {
            if (timeElapsed < lerpDuration)
            {
                float angle = Mathf.LerpAngle(transform.localEulerAngles.y, newAngle, speed * Time.deltaTime);
                transform.localEulerAngles = new Vector3(0, angle, 0);
                timeElapsed += Time.deltaTime;
            }

            else if (timeElapsed >= lerpDuration)
            {
                Mathf.Round(transform.localEulerAngles.z * 100 / 100);

                isDelayed = true;
                timeElapsed = 0.0f;
            }
        }
    }
}
