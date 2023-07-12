using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;

public class keypadButton04 : MonoBehaviour
{
    public static event Action<string> ButtonPressed = delegate { };

    private int deviderPosition;
    private string buttonName, buttonValue;
    private AudioSource sfx;

    void Start()
    {
        buttonName = gameObject.name;
        deviderPosition = buttonName.IndexOf("_");
        buttonValue = buttonName.Substring(0, deviderPosition);

        gameObject.GetComponent<Button>().onClick.AddListener(ButtonClicked);
        sfx = GetComponent<AudioSource>();
    }

    private void ButtonClicked()
    {
        ButtonPressed(buttonValue);
        sfx.Play();
    }
}
