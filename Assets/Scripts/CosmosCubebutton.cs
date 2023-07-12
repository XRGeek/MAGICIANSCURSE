using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;

public class CosmosCubebutton : MonoBehaviour
{
    [SerializeField]
    private Puzzle_3_Behaviour pBehav;
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

    public void ButtonClicked()
    {
        pBehav.addDigitToCodeSequence(buttonName.Substring(0, deviderPosition));
        sfx.Play();
    }
}
