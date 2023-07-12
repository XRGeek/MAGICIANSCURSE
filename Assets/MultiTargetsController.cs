using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultiTargetsController : MonoBehaviour
{

    public CrownKeyCompletion keyCompletion;
    public List<GameObject> allMarkers;
     List<bool> activeMarkers= new List<bool>() { false,false,false,false};
    private int activeOne=-1;

    public int markerNumber = 1;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (activeOne>0)
        {
            allMarkers[0].transform.position = allMarkers[activeOne].transform.position;
            allMarkers[0].transform.rotation = allMarkers[activeOne].transform.rotation;
            allMarkers[0].transform.localScale = allMarkers[activeOne].transform.localScale;

        }
    }

    public void IamActive(int i)
    {
       
        activeMarkers[i] = true;

        UpdateMarkers();
    }

    public void IamInActive(int i)
    {
     
        activeMarkers[i] = false;

        UpdateMarkers();
    }


    void UpdateMarkers()
    {

        activeOne = -1;
        for (int i = 0; i < allMarkers.Count; i++)
        {
            if (activeMarkers[i])
            {
                activeOne = i;
                break;
            }
        }


        if (activeOne == 0)
        {
            if(markerNumber==1)
                keyCompletion.EnableMarker_01();
            else
                keyCompletion.EnableMarker_02();

            allMarkers[1].gameObject.SetActive(false);
            allMarkers[2].gameObject.SetActive(false);
            allMarkers[3].gameObject.SetActive(false);
        }

       else if (activeOne > 0)
        {
            if (markerNumber == 1)
                keyCompletion.EnableMarker_01();
            else
                keyCompletion.EnableMarker_02();

            if (activeOne==1)
            {
                allMarkers[2].gameObject.SetActive(false);
                allMarkers[3].gameObject.SetActive(false);

            }

            else if (activeOne==2)
            {
                allMarkers[1].gameObject.SetActive(false);
                allMarkers[3].gameObject.SetActive(false);

            }

            else if (activeOne == 3)
            {
                allMarkers[2].gameObject.SetActive(false);
                allMarkers[1].gameObject.SetActive(false);

            }

        }
        else
        {
            //keyCompletion.DisableMarker_01();
            if (markerNumber == 1)
                keyCompletion.DisableMarker_01();
            else
                keyCompletion.DisableMarker_02();

            allMarkers[1].gameObject.SetActive(true);
            allMarkers[2].gameObject.SetActive(true);
            allMarkers[3].gameObject.SetActive(true);
        }


     

    }

}
