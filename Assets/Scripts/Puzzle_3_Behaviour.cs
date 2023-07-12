using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Puzzle_3_Behaviour : MonoBehaviour
{
    [SerializeField]
    private Image[] digitsImage;
    [SerializeField]
    private Sprite BlankImage;
    [SerializeField]
    private Sprite[] digits;
    [SerializeField]
    private Image[] radSlider;

    public float waitTime = 10.0f;
    Animator anim;

    private int[] faces;
    public bool faceCoolDown;


    [SerializeField]
    private Image[] characters;

    [SerializeField]
    private int correctCodeA;
    [SerializeField]
    private int correctCodeB;
    [SerializeField]
    private int correctCodeC;
    [SerializeField]
    private int correctCodeD;

    [SerializeField]
    private int codeA;
    [SerializeField]
    private int codeB;
    [SerializeField]
    private int codeC;
    [SerializeField]
    private int codeD;

    private AudioSource sfx;
    [SerializeField]
    private AudioClip[] sfxClip;

    public bool solved = false;
    public string PuzzleName;


    private void OnEnable()
    {
        if (solved)
        {
            sfx = GetComponent<AudioSource>();
            anim = GetComponent<Animator>();

            anim.SetBool("Solved", true);
            GetComponent<SwitchUIHelper>().canSwitchHelper = false;
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
        }
    }

    private void Start()
    {
        sfx = GetComponent<AudioSource>();
        anim = GetComponent<Animator>();
        codeA = 0;
        codeB = 0;
        codeC = 0;
        codeD = 0;
        digits = new Sprite[digitsImage.Length + 1];

        for (int i = 0; i <= digitsImage.Length - 1; i++)
        {
            digits[i] = digitsImage[i].sprite;
        }

        digits[digitsImage.Length] = BlankImage;

        for (int i = 0; i <= characters.Length - 1; i++)
        {
            characters[i].sprite = digits[digitsImage.Length];
        }

        faces = new int[4];
        faceCoolDown = false;

        //CosmosCubebutton.ButtonPressed += addDigitToCodeSequence;
    }

    public void addDigitToCodeSequence(string digitEntered)
    {
        switch (digitEntered)
        {
            case "F1One": codeA = 1; DisplayCodeSequence(1, 1); break;
            case "F1Two": codeA = 2; DisplayCodeSequence(1, 2); break;
            case "F1Three": codeA = 3; DisplayCodeSequence(1, 3); break;
            case "F1Four": codeA = 4; DisplayCodeSequence(1, 4); break;
            case "F1Five": codeA = 5; DisplayCodeSequence(1, 5); break;
            case "F1Six": codeA = 6; DisplayCodeSequence(1, 6); break;
            case "F1Seven": codeA = 7; DisplayCodeSequence(1, 7); break;
            case "F1Eight": codeA = 8; DisplayCodeSequence(1, 8); break;
            case "F1Nine": codeA = 9; DisplayCodeSequence(1, 9); break;

            case "F2One": codeB = 1; DisplayCodeSequence(2, 10); break;
            case "F2Two": codeB = 2; DisplayCodeSequence(2, 11); break;
            case "F2Three": codeB = 3; DisplayCodeSequence(2, 12); break;
            case "F2Four": codeB = 4; DisplayCodeSequence(2, 13); break;
            case "F2Five": codeB = 5; DisplayCodeSequence(2, 14); break;
            case "F2Six": codeB = 6; DisplayCodeSequence(2, 15); break;
            case "F2Seven": codeB = 7; DisplayCodeSequence(2, 16); break;
            case "F2Eight": codeB = 8; DisplayCodeSequence(2, 17); break;
            case "F2Nine": codeB = 9; DisplayCodeSequence(2, 18); break;

            case "F3One": codeC = 1; DisplayCodeSequence(3, 19); break;
            case "F3Two": codeC = 2; DisplayCodeSequence(3, 20); break;
            case "F3Three": codeC = 3; DisplayCodeSequence(3, 21); break;
            case "F3Four": codeC = 4; DisplayCodeSequence(3, 22); break;
            case "F3Five": codeC = 5; DisplayCodeSequence(3, 23); break;
            case "F3Six": codeC = 6; DisplayCodeSequence(3, 24); break;
            case "F3Seven": codeC = 7; DisplayCodeSequence(3, 25); break;
            case "F3Eight": codeC = 8; DisplayCodeSequence(3, 26); break;
            case "F3Nine": codeC = 9; DisplayCodeSequence(3, 27); break;

            case "F4One": codeD = 1; DisplayCodeSequence(4, 28); break;
            case "F4Two": codeD = 2; DisplayCodeSequence(4, 29); break;
            case "F4Three": codeD = 3; DisplayCodeSequence(4, 30); break;
            case "F4Four": codeD = 4; DisplayCodeSequence(4, 31); break;
            case "F4Five": codeD = 5; DisplayCodeSequence(4, 32); break;
            case "F4Six": codeD = 6; DisplayCodeSequence(4, 33); break;
            case "F4Seven": codeD = 7; DisplayCodeSequence(4, 34); break;
            case "F4Eight": codeD = 8; DisplayCodeSequence(4, 35); break;
            case "F4Nine": codeD = 9; DisplayCodeSequence(4, 36); break;
        }

        if (codeA != 0 && codeB != 0 && codeC != 0 && codeD != 0)
        {
            CheckResults();
        }
    }


    public void DisplayCodeSequence(int cubeSide, int digitJustEntered)
    {
        if (!faceCoolDown)
        {
            radSlider[0].fillAmount = 0;
            radSlider[1].fillAmount = 0;
            radSlider[2].fillAmount = 0;
            radSlider[3].fillAmount = 0;
            faceCoolDown = true;
            sfx.clip = sfxClip[2];
            sfx.loop = true;
            sfx.playOnAwake = true;
            sfx.volume = 0.1f;
            sfx.Play();
        }

        switch (cubeSide)
        {
            case 1:
                characters[0].sprite = digits[digitJustEntered-1];
                break;
            case 2:
                characters[1].sprite = digits[digitJustEntered-1];
                break;
            case 3:
                characters[2].sprite = digits[digitJustEntered-1];
                break;
            case 4:
                characters[3].sprite = digits[digitJustEntered-1];
                break;
        }
    }


    void Update()
    {
        if (radSlider[0].fillAmount >= 0.996)
        {
            ResetDisplay();
        }

        //Increase fill amount over X seconds
        if (faceCoolDown)
        {
            radSlider[0].fillAmount += 1.0f / waitTime * Time.deltaTime;
            radSlider[1].fillAmount += 1.0f / waitTime * Time.deltaTime;
            radSlider[2].fillAmount += 1.0f / waitTime * Time.deltaTime;
            radSlider[3].fillAmount += 1.0f / waitTime * Time.deltaTime;
        }


    }

    private void CheckResults()
    {
        if (codeA == correctCodeA && codeB == correctCodeB && codeC == correctCodeC && codeD == correctCodeD)
        {
            anim.SetBool("Solved", true);
            sfx.Play();
            GetComponent<SwitchUIHelper>().canSwitchHelper = false;
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
            sfx.clip = sfxClip[0];
            sfx.loop = false;
            sfx.playOnAwake = false;
            sfx.volume = 0.5f;
            sfx.Play();
            SolvePuzzle();
        }
        else
        {
            ResetDisplay();
        }
    }

    private void ResetDisplay()
    {
        for (int i = 0; i <= characters.Length - 1; i++)
        {
            characters[i].sprite = digits[digitsImage.Length];
            radSlider[i].fillAmount = 0;
            faceCoolDown = false;
        }
        sfx.clip = sfxClip[1];
        sfx.loop = false;
        sfx.playOnAwake = false;
        sfx.volume = 0.5f;
        sfx.Play();

        codeA = 0;
        codeB = 0;
        codeC = 0;
        codeD = 0;
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
