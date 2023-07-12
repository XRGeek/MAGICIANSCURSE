using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;

public class PotionPushTheButton : MonoBehaviour
{
    public static event Action<string> ButtonPressed = delegate { };
    private Button btn;
    private int deviderPosition;
    private string buttonName, buttonValue;
    private Animator anim;

    void Start()
    {
        anim = GetComponent<Animator>();
        buttonName = gameObject.name;
        deviderPosition = buttonName.IndexOf("_");
        buttonValue = buttonName.Substring(0, deviderPosition);

        btn = GetComponent<Button>();
        btn.onClick.AddListener(ButtonClicked);
    }

    private void ButtonClicked()
    {
        btn.interactable = false;
        ButtonPressed(buttonValue);
        anim.SetBool("Pressed", true);
    }

    public void ResetButton()
    {
        btn.interactable = true;
        anim.SetBool("Reset", true);
    }
}
