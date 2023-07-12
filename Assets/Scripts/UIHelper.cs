using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIHelper : MonoBehaviour
{
    // none // ID 0
    // prefTap // ID 1
    // prefDrag // ID 2
    // prefSwipe // ID 3
    // prefHold // ID 4
    // prefCamZoom // ID 5
    // prefCamMarker // ID 6

    float HelpersLife = 10;

    [SerializeField]
    private GameObject[] prefHelpers;

    private int currentHelperID;
    float waitTime = 20f;

    void Start()
    {
        currentHelperID = 0;
    }

    public void TriggerHelper()
    {
        prefHelpers[currentHelperID].SetActive(true);
    }

    public void ChangeHelperType(int helperType)
    {
        currentHelperID = helperType;
        for (int i = 0; i< prefHelpers.Length; i++)
        {
            prefHelpers[i].SetActive(false);
        }
        StopCoroutine("WaitForInput");
        StartCoroutine("WaitForInput");
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            prefHelpers[currentHelperID].SetActive(false);
            StopCoroutine("WaitForInput");
            StartCoroutine("WaitForInput");
        }
        if (Input.touchCount > 0)
        {
            prefHelpers[currentHelperID].SetActive(false);
            StopCoroutine("WaitForInput");
            StartCoroutine("WaitForInput");
        }
    }

    private IEnumerator WaitForInput()
    {
        yield return new WaitForSeconds(waitTime);
        TriggerHelper();
        StartCoroutine("DisableHelperAfterUse");
    }

    private IEnumerator DisableHelperAfterUse()
    {
        yield return new WaitForSeconds(HelpersLife);
        prefHelpers[currentHelperID].SetActive(false);
        StartCoroutine("WaitForInput");
    }
}
