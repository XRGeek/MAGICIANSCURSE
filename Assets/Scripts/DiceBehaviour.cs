using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class DiceBehaviour : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{  
    private bool selected = false;
    public bool interactable = false;
    [SerializeField]
    private Transform ITTargetPosition;
    [SerializeField]
    private Transform cameraZoomTarget;
    [SerializeField]
    Vector3 offsetAngleStart;
    float lerpDuration = 1f;
    [SerializeField]
    float timeElapsed = 0.0f;
    private float speed = 8.0f;

    private float rotateSpeedModifier = 3f;
    public bool isDragged;
    [SerializeField]
    private AudioSource sfx;
    [SerializeField]
    private AudioClip[] sfxClips;
    private bool forceReset = false;

    private void Awake()
    {
        sfx = GetComponent<AudioSource>();
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        if (!interactable)
            return;
        isDragged = true;
        sfx.clip = sfxClips[2];
        sfx.Play();
    }

    public void OnDrag(PointerEventData data)
    {
        if (!interactable)
            return;
  
        if (selected)
        {
            Vector2 delta = new Vector2(Input.GetAxis("Mouse X"), Input.GetAxis("Mouse Y"));
            Vector3 camRot = Camera.main.transform.eulerAngles;

            transform.RotateAround(cameraZoomTarget.position, cameraZoomTarget.right * rotateSpeedModifier, delta.y * rotateSpeedModifier);
            transform.RotateAround(cameraZoomTarget.position, cameraZoomTarget.up * rotateSpeedModifier, -delta.x * rotateSpeedModifier);
        }
        isDragged = true;
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        isDragged = false;
    }

    public void ChangeSelectState(bool state)
    {
        selected = state;
        if (selected)
        {
            transform.parent = cameraZoomTarget;
            if (sfx.enabled == true)
            {
                sfx.clip = sfxClips[0];
                sfx.Play();
            }
        }
        else
        {
            transform.parent = ITTargetPosition;
            if (sfx.enabled == true)
            {
                sfx.clip = sfxClips[1];
                sfx.Play();
            }
        }
    }

    public void ForceReset()
    {
        forceReset = true;
    }

    void Update()
    {
        if (forceReset)
        {
            selected = false;
            transform.parent = ITTargetPosition;
            if (timeElapsed < lerpDuration)
            {
                transform.position = Vector3.Lerp(transform.position, ITTargetPosition.position, speed * Time.deltaTime / lerpDuration);
                transform.rotation = Quaternion.Lerp(transform.rotation, ITTargetPosition.rotation, speed * Time.deltaTime / lerpDuration);
                transform.localScale = Vector3.Lerp(transform.localScale, ITTargetPosition.localScale, speed * Time.deltaTime / lerpDuration);
                timeElapsed += Time.deltaTime;
            }
            else if (timeElapsed >= lerpDuration)
            {
                timeElapsed = 0.0f;
                Round(transform.eulerAngles);
                Round(transform.position);
                interactable = true;
                forceReset = false;
            }

            return;
        }

        if (!interactable && !isDragged)
        {
            if (selected)
            {
                if (timeElapsed < lerpDuration)
                {
                    Quaternion startangle = Quaternion.Euler(offsetAngleStart.x, offsetAngleStart.y, offsetAngleStart.z);

                    transform.position = Vector3.Lerp(transform.position, cameraZoomTarget.position, speed * Time.deltaTime / lerpDuration);
                    transform.rotation = Quaternion.Lerp(transform.rotation, cameraZoomTarget.rotation * startangle, speed * Time.deltaTime / lerpDuration);
                    transform.localScale = Vector3.Lerp(transform.localScale, cameraZoomTarget.localScale, speed * Time.deltaTime / lerpDuration);
                    timeElapsed += Time.deltaTime;
                }
                else if (timeElapsed >= lerpDuration)
                {
                    timeElapsed = 0.0f;
                    Round(transform.eulerAngles);
                    Round(transform.position);
                    interactable = true;
                }
            }

            else
            {
                if (timeElapsed < lerpDuration)
                {
                    transform.position = Vector3.Lerp(transform.position, ITTargetPosition.position, speed * Time.deltaTime / lerpDuration);
                    transform.rotation = Quaternion.Lerp(transform.rotation, ITTargetPosition.rotation, speed * Time.deltaTime / lerpDuration);
                    transform.localScale = Vector3.Lerp(transform.localScale, ITTargetPosition.localScale, speed * Time.deltaTime / lerpDuration);
                    timeElapsed += Time.deltaTime;
                }
                else if (timeElapsed >= lerpDuration)
                {
                    timeElapsed = 0.0f;
                    Round(transform.eulerAngles);
                    Round(transform.position);
                    interactable = true;
                }
            }
        }

    }

    public static Vector3 Round(Vector3 vector3, int decimalPlaces = 2)
    {
        float multiplier = 1;
        for (int i = 0; i < decimalPlaces; i++)
        {
            multiplier *= 10f;
        }
        return new Vector3(
            Mathf.Round(vector3.x * multiplier) / multiplier,
            Mathf.Round(vector3.y * multiplier) / multiplier,
            Mathf.Round(vector3.z * multiplier) / multiplier);
    }
}