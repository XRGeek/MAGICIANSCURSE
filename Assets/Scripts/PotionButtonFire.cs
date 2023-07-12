using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;

public class PotionButtonFire : MonoBehaviour
{
    [SerializeField]
    private PotionBehaviour pBehav;
    [SerializeField]
    private Button btn;
    private int deviderPosition;
    private string buttonName, buttonValue;
    private Animator anim;

    void Awake()
    {
        anim = GetComponent<Animator>();
        buttonName = gameObject.name;
        deviderPosition = buttonName.IndexOf("_");
        buttonValue = buttonName.Substring(0, deviderPosition);
    }

    public void ButtonClicked()
    {
        pBehav.addDigitToCodeSequence(buttonName.Substring(0, deviderPosition));
    }

    public void ResetButton()
    {
        if (anim != null)
            anim.SetBool("Reset", true);
        btn.interactable = true;
    }
    public void DisableButton()
    {
        if (anim != null)
            anim.SetBool("Pressed", true);
        btn.interactable = false;
    }
}
