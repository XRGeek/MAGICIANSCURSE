using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MusicSandCardPuzzle : MonoBehaviour
{
    [SerializeField]
    private bool[] ppCards;
    [SerializeField]
    private DragDrop[] cards;
    [SerializeField]
    private GameObject vPlayer;

    [SerializeField]
    private AudioSource voice;
    [SerializeField]
    private AudioClip voice_German;
    [SerializeField]
    private AudioClip voice_French;
    [SerializeField]
    private AudioClip voice_English;

    [SerializeField]
    private AudioClip voice_Success;

    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if (solved)
        {
            //vPlayer.SetActive(true);
            //voice.Play();
            PlaySuccess();
            GetComponent<SwitchUIHelper>().canSwitchHelper = false;
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
            for (int i = 0; i < cards.Length; i++)
                cards[i].enabled = false;
        }
    }

    private void Start()
    {

        AssignVoice();
        ppCards = new bool[10];
        for (int i = 0; i < ppCards.Length; i++)
        {
            ppCards[i] = false;
        }
    }

    private void AssignVoice()
    {
        switch (GleyLocalization.Manager.GetCurrentLanguage().ToString())
        {
            // English
            case "English":
                voice.clip = voice_English;
                break;
            // French
            case "French":
                voice.clip = voice_French;
                break;
            // German
            case "German":
                voice.clip = voice_German;
                break;
        }
    }

    public void UpdateCards(int pID, bool state)
    {
        ppCards[pID] = state;
    }

    void Update()
    {
        if (solved)
            return;
        if (isPuzzleComplete())
        {
            SolvePuzzle();

            PlaySuccess();

            GetComponent<SwitchUIHelper>().canSwitchHelper = false;
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
        }
    }

    void PlaySuccess()
    {
        vPlayer.SetActive(true);
        voice.Stop();
        voice.clip = voice_Success;
        voice.Play();
        Invoke("ActivateSound", 2.75f);
    }

    void ActivateSound()
    {
        voice.Stop();
        AssignVoice();
        voice.Play();
    }

    private bool isPuzzleComplete()
    {


#if UNITY_EDITOR
        if (Input.GetKey(KeyCode.Q))
        {
            return true;
        }
#endif


        for (int i = 0; i < ppCards.Length; i++)
        {
            if (ppCards[i] == false)            
                return false;            
        }
        for (int i = 0; i < cards.Length; i++)     
            cards[i].enabled = false;
        
        return true;
    }
    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }
}
