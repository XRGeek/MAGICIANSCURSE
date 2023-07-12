using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchUIHelper : MonoBehaviour
{
    public bool canSwitchHelper;
    [SerializeField]
    private int helperType;

    private void OnEnable()
    {
        if (canSwitchHelper)
        {
            UIHelper h = GameObject.Find("Helpers").GetComponent<UIHelper>();
            h.ChangeHelperType(helperType);
        }
    }

    private void OnDisable()
    {
        if (canSwitchHelper)
        {
            UIHelper h;
            if (h = GameObject.Find("Helpers").GetComponent<UIHelper>()) 
                h.ChangeHelperType(0);
        }
    }
}
