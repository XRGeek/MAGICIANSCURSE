using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Potion_Display : MonoBehaviour
{
    [SerializeField]
    private Animator eyeAnim;

    [SerializeField]
    private Sprite[] digits;

    [SerializeField]
    private Image[] characters;

    [SerializeField]
    private string correctCodeSequence;

    private string codeSequence;
    [SerializeField]
    private int keypadID;

    void Start()
    {
        codeSequence = "";

        for (int i = 0; i <= characters.Length - 1; i++)
        {
            characters[i].sprite = digits[10];
        }
        switch(keypadID)
        {
            case 1:
                //PotionButtonIce.ButtonPressed += addDigitToCodeSequence;
                break;
            case 2:
                //PotionButtonFire.ButtonPressed += addDigitToCodeSequence;
                break;
            case 3:
                //PotionButtonNature.ButtonPressed += addDigitToCodeSequence;
                break;
            case 4:
                //PotionButtonWind.ButtonPressed += addDigitToCodeSequence;
                break;
        }
    }

    private void addDigitToCodeSequence(string digitEntered)
    {
        if (codeSequence.Length < codeSequence.Length)
        {
            switch (digitEntered)
            {
                case "Zero":
                    codeSequence += "0";
                    break;
                case "One":
                    codeSequence += "1";
                    break;
                case "Two":
                    codeSequence += "2";
                    break;
                case "Three":
                    codeSequence += "3";
                    break;
                case "Four":
                    codeSequence += "4";
                    break;
                case "Five":
                    codeSequence += "5";
                    break;
                case "Six":
                    codeSequence += "6";
                    break;
                case "Seven":
                    codeSequence += "7";
                    break;
                case "Eight":
                    codeSequence += "8";
                    break;
            }
        }
        else
            CheckResults();        
    }

    private void CheckResults()
    {
        if (codeSequence == correctCodeSequence)
        {
            Debug.Log("correct");
            eyeAnim.SetBool("Solved", true);
        }
        else
        {
            Debug.Log("incorrect");
            ResetDisplay();
        }
    }

    private void ResetDisplay()
    {
        for (int i = 0; i <= characters.Length - 1; i++)
        {
            characters[i].sprite = digits[10];
        }
        codeSequence = "";
    }

    private void OnDestroy()
    {
        PushTheButton.ButtonPressed -= addDigitToCodeSequence;
    }
}
