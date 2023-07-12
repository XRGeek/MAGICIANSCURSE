using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class PotionBehaviour : MonoBehaviour
{
    [SerializeField]
    private string[] correctCodeSequence;
    [SerializeField]
    private string codeSequence;
    private Animator anim;
    [SerializeField]
    private GameObject[] btns;
    private PotionButtonIce[] btnsIce;
    private PotionButtonFire[] btnsFire;
    private PotionButtonNature[] btnsNature;
    private PotionButtonWind[] btnsWind;

    private AudioSource sfx;
    [SerializeField]
    private AudioClip[] sfxClip;
    [SerializeField]
    private int keypadID;

    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if (!sfx)
            sfx = GetComponent<AudioSource>();
        if (!anim)
            anim = GetComponent<Animator>();
        if (solved)
        {
            anim.SetBool("Solved", true);
            sfx.clip = sfxClip[0];
            solved = true;
            GetComponent<SwitchUIHelper>().canSwitchHelper = false;
            SetupKeypad();
            DisableButtons();
        }
    }

    void Start()
    {
        codeSequence = "";
        sfx = GetComponent<AudioSource>();
        anim = GetComponent<Animator>();
        //PotionPushTheButton.ButtonPressed += addDigitToCodeSequence;
        SetupKeypad();
    }

    private void DisableCurrentButton(int buttonID)
    {
        switch (keypadID)
        {
            case 1:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsIce[buttonID-1].DisableButton();
                }
                break;

            case 2:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsFire[buttonID - 1].DisableButton();
                }
                break;

            case 3:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsNature[buttonID - 1].DisableButton();
                }
                break;

            case 4:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsWind[buttonID - 1].DisableButton();
                }
                break;
        }

    }
    private void DisableButtons()
    {
        switch (keypadID)
        {
            case 1:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsIce[i].DisableButton();
                }
                break;

            case 2:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsFire[i].DisableButton();
                }
                break;

            case 3:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsNature[i].DisableButton();
                }
                break;

            case 4:
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsWind[i].DisableButton();
                }
                break;
        }

    }
    private void SetupKeypad()
    {
        switch (keypadID)
        {
            case 1:
                btnsIce = new PotionButtonIce[btns.Length];
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsIce[i] = btns[i].GetComponent<PotionButtonIce>();
                }
                //PotionButtonIce.ButtonPressed += addDigitToCodeSequence;
                break;

            case 2:
                btnsFire = new PotionButtonFire[btns.Length];
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsFire[i] = btns[i].GetComponent<PotionButtonFire>();
                }
                //PotionButtonFire.ButtonPressed += addDigitToCodeSequence;
                break;

            case 3:
                btnsNature = new PotionButtonNature[btns.Length];
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsNature[i] = btns[i].GetComponent<PotionButtonNature>();
                }
                //PotionButtonNature.ButtonPressed += addDigitToCodeSequence;
                break;

            case 4:
                btnsWind = new PotionButtonWind[btns.Length];
                for (int i = 0; i < btns.Length; i++)
                {
                    btnsWind[i] = btns[i].GetComponent<PotionButtonWind>();
                }
                //PotionButtonWind.ButtonPressed += addDigitToCodeSequence;
                break;
        }
    }

    public void addDigitToCodeSequence(string digitEntered)
    {
        if (codeSequence.Length < correctCodeSequence[0].Length)
        {
            switch(digitEntered)
            {
                case "Zero":
                    codeSequence += "0";
                    DisableCurrentButton(0);
                    break;
                case "One":
                    codeSequence += "1";
                    DisableCurrentButton(1);
                    break;
                case "Two":
                    codeSequence += "2";
                    DisableCurrentButton(2);
                    break;
                case "Three":
                    codeSequence += "3";
                    DisableCurrentButton(3);
                    break;
                case "Four":
                    codeSequence += "4";
                    DisableCurrentButton(4);
                    break;
                case "Five":
                    codeSequence += "5";
                    DisableCurrentButton(5);
                    break;
                case "Six":
                    codeSequence += "6";
                    DisableCurrentButton(6);
                    break;
                case "Seven":
                    codeSequence += "7";
                    DisableCurrentButton(7);
                    break;
                case "Eight":
                    codeSequence += "8";
                    DisableCurrentButton(8);
                    break;
            }
        }
        if (codeSequence.Length >= correctCodeSequence[0].Length)
        {
            CheckResults();
        }
    }

    public bool IsCodeLenghAtMax()
    {
        Debug.Log("codeSequence.Length = " + codeSequence.Length);

        if (codeSequence.Length == correctCodeSequence.Length)
            return true;
        else
            return false;
    }

    private void CheckResults()
    {
        for(int i = 0; i < correctCodeSequence.Length; i++)
        {
            if (codeSequence == correctCodeSequence[i])
            {
                if (sfx != null)
                    sfx.clip = sfxClip[0];
                solved = true;
                anim.SetBool("Solved", true);
                GetComponent<SwitchUIHelper>().canSwitchHelper = false;
                SolvePuzzle();
                DisableButtons();
                return;
            }
        }
        ResetDisplay();
    }

    private void ResetDisplay()
    {
        codeSequence = "";
        if (sfx != null)
        {
            sfx.clip = sfxClip[1];
            sfx.Play();
        }


        for (int i = 0; i < btns.Length; i++)
        {
            switch(keypadID)
            {
                case 1:
                    btnsIce[i].ResetButton();
                    break;

                case 2:
                    btnsFire[i].ResetButton();
                    break;

                case 3:
                    btnsNature[i].ResetButton();
                    break;

                case 4:
                    btnsWind[i].ResetButton();
                    break;
            }
        }
    }

    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }
    private void OnDestroy()
    {
        PushTheButton.ButtonPressed -= addDigitToCodeSequence;
    }
}
