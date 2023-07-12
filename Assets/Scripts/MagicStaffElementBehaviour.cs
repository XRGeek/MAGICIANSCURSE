using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MagicStaffElementBehaviour : MonoBehaviour
{
    [SerializeField]
    GameObject staffFire;
    [SerializeField]
    GameObject staffIce;
    [SerializeField]
    GameObject staffNature;
    [SerializeField]
    GameObject staffWind;
    [SerializeField]
    GameObject staffNormal;

    [SerializeField]
    bool fireDetected;
    [SerializeField]
    bool iceDetected;
    [SerializeField]
    bool natureDetected;
    [SerializeField]
    bool windDetected;

    [SerializeField]
    bool fireInPosition = false;
    [SerializeField]
    bool iceInPosition = false;
    [SerializeField]
    bool natureInPosition = false;
    [SerializeField]
    bool windInPosition = false;
    [SerializeField]
    Transform fireTarget;
    [SerializeField]
    Transform iceTarget;
    [SerializeField]
    Transform natureTarget;
    [SerializeField]
    Transform windTarget;

    private void OnDisable()
    {
        iceInPosition = false;
        fireInPosition = false;
        natureInPosition = false;
        windInPosition = false;
    }
    private void OnTriggerEnter(Collider other)
    {
        float dist;

        if (other.name == "Collider_Ice")
        {
            dist = Vector3.Distance(other.transform.position, iceTarget.position);
            if (dist < 0.05f)
                iceInPosition = true;
        }

        if (other.name == "Collider_Fire")
        {
            dist = Vector3.Distance(other.transform.position, fireTarget.position);
            if (dist < 0.05f)
                fireInPosition = true;
        }

        if (other.name == "Collider_Nature")
        {
            dist = Vector3.Distance(other.transform.position, natureTarget.position);
            if (dist < 0.05f)
                natureInPosition = true;
        }

        if (other.name == "Collider_Wind")
        {
            dist = Vector3.Distance(other.transform.position, windTarget.position);
            if (dist < 0.05f) 
                windInPosition = true;
        }

        CheckElement();
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.name == "Collider_Ice")
        {
            iceInPosition = false;

            staffNormal.transform.rotation = staffIce.transform.rotation;
            staffIce.SetActive(false);
            staffNormal.SetActive(true);
        }
        if (other.name == "Collider_Fire")
        {
            fireInPosition = false;

            staffNormal.transform.rotation = staffFire.transform.rotation;
            staffFire.SetActive(false);
            staffNormal.SetActive(true);
        }
        if (other.name == "Collider_Nature")
        {
            natureInPosition = false;

            staffNormal.transform.rotation = staffNature.transform.rotation;
            staffNature.SetActive(false);
            staffNormal.SetActive(true);
        }
        if (other.name == "Collider_Wind")
        {
            windInPosition = false;

            staffNormal.transform.rotation = staffWind.transform.rotation;
            staffWind.SetActive(false);
            staffNormal.SetActive(true);
        }
    }

    void CheckElement()
    {
        if (fireInPosition && fireDetected)
        {
            staffFire.SetActive(true);
            staffFire.transform.rotation = staffNormal.transform.rotation;

            staffIce.SetActive(false);
            staffNature.SetActive(false);
            staffWind.SetActive(false);
            staffNormal.SetActive(false);
        }

        if (iceInPosition && iceDetected)
        {
            staffFire.SetActive(false);
            staffIce.SetActive(true);
            staffIce.transform.rotation = staffNormal.transform.rotation;

            staffNature.SetActive(false);
            staffWind.SetActive(false);
            staffNormal.SetActive(false);
        }

        if (natureInPosition && natureDetected)
        {
            staffFire.SetActive(false);
            staffIce.SetActive(false);
            staffNature.SetActive(true);
            staffNature.transform.rotation = staffNormal.transform.rotation;

            staffWind.SetActive(false);
            staffNormal.SetActive(false);
        }

        if (windInPosition && windDetected)
        {
            staffFire.SetActive(false);
            staffIce.SetActive(false);
            staffNature.SetActive(false);
            staffWind.SetActive(true);
            staffWind.transform.rotation = staffNormal.transform.rotation;

            staffNormal.SetActive(false);
        }
    }
    //---------------------------------------------------------------------------------------------------//

    public void DetectFire()
    {
        fireDetected = true;
        CheckElement();
    }
    public void LostFire()
    {
        fireDetected = false;
        fireInPosition = false;
        staffNormal.transform.rotation = staffFire.transform.rotation;
        staffFire.SetActive(false);
        staffNormal.SetActive(true);
    }
    //---------------------------------------------------------------------------------------------------//

    public void DetectIce()
    { 
        iceDetected = true;
        CheckElement();
    }
    public void LostIce()
    { 
        iceDetected = false;
        iceInPosition = false;

        staffNormal.transform.rotation = staffIce.transform.rotation;
        staffIce.SetActive(false);
        staffNormal.SetActive(true);
    }
    //---------------------------------------------------------------------------------------------------//

    public void DetecNature()
    { 
        natureDetected = true;
        CheckElement();
    }

    public void LostNature()
    { 
        natureDetected = false;
        natureInPosition = false;
        staffNormal.transform.rotation = staffNature.transform.rotation;
        staffNature.SetActive(false);
        staffNormal.SetActive(true);
    }
    //---------------------------------------------------------------------------------------------------//

    public void DetecWind()
    { 
        windDetected = true;
        CheckElement();
    }
    public void LostWind()
    { 
        windDetected = false;
        windInPosition = false;
        staffNormal.transform.rotation = staffWind.transform.rotation;
        staffWind.SetActive(false);
        staffNormal.SetActive(true);
    }
    //---------------------------------------------------------------------------------------------------//
}
