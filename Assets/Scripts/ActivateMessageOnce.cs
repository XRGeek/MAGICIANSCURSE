using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateMessageOnce : MonoBehaviour
{
    [SerializeField]
    private GameObject message;
    bool activatedOnce = false;

    public void ActivateOnce()
    {
        if(!activatedOnce)
        {
            message.SetActive(true);
            activatedOnce = true;
        }
    }

    public void CancelActivate()
    {
        message.SetActive(false);
        activatedOnce = true;
    }
}
