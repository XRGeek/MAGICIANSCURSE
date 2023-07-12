using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextMessageFade : MonoBehaviour
{
    Animator anim;
    [SerializeField]
    float startDelay = 8f;
    [SerializeField]
    float delay = 5f;
    bool canSkip;
    [SerializeField]
    private GameObject parent;
    private AudioSource voice;
    [SerializeField]
    private AudioClip voice_German;
    [SerializeField]
    private AudioClip voice_French;
    [SerializeField]
    private AudioClip voice_English;
    [SerializeField]
    private bool playTextAnim;

    void Start()
    {
        anim = GetComponent<Animator>();
        voice = parent.GetComponent<AudioSource>();
        anim.enabled = false;
        StartCoroutine("WaitToFade");
        canSkip = false;

        switch(GleyLocalization.Manager.GetCurrentLanguage().ToString())
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

    public void SkipText()
    {
        if (canSkip)
        {
            StopCoroutine("WaitToFade");
            anim.SetBool("Skip", true);
            StartCoroutine("SkippingText");
        }
    }
    IEnumerator WaitToFade()
    {
        canSkip = false;
        anim.SetBool("Skip", false);
        anim.enabled = false;
        yield return new WaitForSeconds(startDelay);
        if(playTextAnim)
            anim.enabled = true;
        voice.Play();
        yield return new WaitForSeconds(1f);
        canSkip = true;
        yield return new WaitForSeconds(delay);
        anim.SetBool("Skip", true);
        yield return new WaitForSeconds(2);
        parent.SetActive(false);
    }

    IEnumerator SkippingText()
    {
        yield return new WaitForSeconds(2);
        parent.SetActive(false);
    }
}
