using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalScript : MonoBehaviour
{


    public GemBehaviour gem1, gem2, gem3;
    private bool isActive = false;

    public bool IsActive { get => isActive; set => isActive = value; }


    private void Start()
    {
        
    }

    public void PortalActive()
    {
        isActive = true;

        gem1.PortalActive();
        gem2.PortalActive();
        gem3.PortalActive();
       
    }

    public void PortalNotActive()
    {
        gem1.PortalNotActive();
        gem2.PortalNotActive();
        gem3.PortalNotActive();

        isActive = false;
        //Invoke("Delay_DisableMarker_01", 0.7f);
    }

    private void Delay_DisableMarker_01()
    {
        //gem1.PortalNotActive();
        //gem2.PortalNotActive();
        //gem3.PortalNotActive();
        //isActive = false;
    }
}
