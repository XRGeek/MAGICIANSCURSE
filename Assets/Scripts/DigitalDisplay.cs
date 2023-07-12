using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class DigitalDisplay : MonoBehaviour
{
    [SerializeField]
    private Animator eyeAnim;
    [SerializeField]
    private Animator uiAnim;

    [SerializeField]
    private Sprite[] digits;

    [SerializeField]
    private Image[] characters;

    [SerializeField]
    private string correctCodeSequence;
    private string codeSequence;

    [SerializeField]
    private AudioClip[] sfxClips;
    private AudioSource sfx;
    [SerializeField]
    private GameObject endMessage;
    [SerializeField]
    private int keypadID;

    public bool solved = false;
    public string PuzzleName;
    [SerializeField]
    ActivateMessageOnce startMsg;

    private void OnEnable()
    {        
        if (solved)
        {
            if (startMsg)
                startMsg.CancelActivate();
            sfx = GetComponent<AudioSource>();

            eyeAnim.SetBool("Solved", true);
            uiAnim.SetBool("Solved", true);
            sfx.clip = sfxClips[1];
            sfx.Play();
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
            endMessage.SetActive(true);
        }
    }

    void Start()
    {
        codeSequence = "";
        sfx = GetComponent<AudioSource>();
        for (int i = 0; i <= characters.Length - 1; i++) 
        {
            characters[i].sprite = digits[10];
        }

        switch(keypadID)
        {
            case 1:
                keypadButton01.ButtonPressed += addDigitToCodeSequence;
                break;
            case 2:
                keypadButton02.ButtonPressed += addDigitToCodeSequence;
                break;
            case 3:
                keypadButton03.ButtonPressed += addDigitToCodeSequence;
                break;
            case 4:
                keypadButton04.ButtonPressed += addDigitToCodeSequence;
                break;
            case 5:
                keypadButton05.ButtonPressed += addDigitToCodeSequence;
                break;
        }
    }

    private void addDigitToCodeSequence(string digitEntered)
    {
        if (codeSequence.Length < 4)
        {
            switch(digitEntered)
            {
                case "Zero":
                    codeSequence += "0";
                    DisplayCodeSequence(0);
                    break;
                case "One":
                    codeSequence += "1";
                    DisplayCodeSequence(1);
                    break;
                case "Two":
                    codeSequence += "2";
                    DisplayCodeSequence(2);
                    break;
                case "Three":
                    codeSequence += "3";
                    DisplayCodeSequence(3);
                    break;
                case "Four":
                    codeSequence += "4";
                    DisplayCodeSequence(4);
                    break;
                case "Five":
                    codeSequence += "5";
                    DisplayCodeSequence(5);
                    break;
                case "Six":
                    codeSequence += "6";
                    DisplayCodeSequence(6);
                    break;
                case "Seven":
                    codeSequence += "7";
                    DisplayCodeSequence(7);
                    break;
                case "Eight":
                    codeSequence += "8";
                    DisplayCodeSequence(8);
                    break;
                case "Nine":
                    codeSequence += "9";
                    DisplayCodeSequence(9);
                    break;
            }
        }
        if (codeSequence.Length == 4)
        {
            CheckResults();
        }

        switch (digitEntered)
        {
            case "Star":
                ResetDisplay();
                break;
            case "Hash":
                if (codeSequence.Length > 0)
                {
                    codeSequence = codeSequence.Substring(0, codeSequence.Length - 1);
                }

                characters[3].sprite = characters[2].sprite;
                characters[2].sprite = characters[1].sprite;
                characters[1].sprite = characters[0].sprite;
                characters[0].sprite = digits[10];
                break;
        }
    }

    private void DisplayCodeSequence(int digitJustEntered)
    {
        switch (codeSequence.Length)
        {
            case 1:
                characters[0].sprite = digits[10];
                characters[1].sprite = digits[10];
                characters[2].sprite = digits[10];
                characters[3].sprite = digits[digitJustEntered];
                Debug.Log("case 1");
                break;
            case 2:
                characters[0].sprite = digits[10];
                characters[1].sprite = digits[10];
                characters[2].sprite = characters[3].sprite;
                characters[3].sprite = digits[digitJustEntered];
                Debug.Log("case 2");
                break;
            case 3:
                characters[0].sprite = digits[10];
                characters[1].sprite = characters[2].sprite;
                characters[2].sprite = characters[3].sprite;
                characters[3].sprite = digits[digitJustEntered];
                Debug.Log("case 3");
                break;
            case 4:
                characters[0].sprite = characters[1].sprite;
                characters[1].sprite = characters[2].sprite;
                characters[2].sprite = characters[3].sprite;
                characters[3].sprite = digits[digitJustEntered];
                Debug.Log("case 4");
                break;
        }
    }

    private void CheckResults()
    {
        if(codeSequence == correctCodeSequence)
        {
            eyeAnim.SetBool("Solved", true);
            uiAnim.SetBool("Solved", true);
            sfx.clip = sfxClips[1];
            sfx.Play();
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
            endMessage.SetActive(true);
            SolvePuzzle();
        }
        else
        {
            ResetDisplay();
            sfx.clip = sfxClips[0];
            sfx.Play();
        }
    }

    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
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
        keypadButton01.ButtonPressed -= addDigitToCodeSequence;
        keypadButton02.ButtonPressed -= addDigitToCodeSequence;
        keypadButton03.ButtonPressed -= addDigitToCodeSequence;
        keypadButton04.ButtonPressed -= addDigitToCodeSequence;
        keypadButton05.ButtonPressed -= addDigitToCodeSequence;
    }
}
