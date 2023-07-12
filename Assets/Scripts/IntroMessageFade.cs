using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntroMessageFade : MonoBehaviour
{
    Animator anim;
    [SerializeField]
    float startDelay = 8f;
    [SerializeField]
    float delay = 5f;
    bool canSkip;
    bool miniature;
    [SerializeField]
    private GameObject parent;
    private AudioSource sfx;
    public bool solved = false;
    void Start()
    {
        if (solved)
            return;
        miniature = false;
        anim = GetComponent<Animator>();
        sfx = parent.GetComponent<AudioSource>();
        anim.enabled = false;
        StartCoroutine("StartWaitToFade");
        canSkip = false;
    }

    public void SkipText()
    {
        if (miniature)
        {
            if (canSkip)
            {
                StopCoroutine("WaitToFade");
                anim.SetBool("Skip", true);
                StartCoroutine("SkippingText");
                miniature = false;
            }
        }
        else
        {
            if (canSkip)
            {
                StopCoroutine("SkippingText");
                anim.SetBool("Skip", false);
                StartCoroutine("WaitToFade");
                miniature = true;
            }
        }
    }
    IEnumerator StartWaitToFade()
    {
        canSkip = false;
        anim.SetBool("Skip", false);
        anim.enabled = false;
        yield return new WaitForSeconds(startDelay);
        anim.enabled = true;
        sfx.Play();
        yield return new WaitForSeconds(1f);
        canSkip = true;
        yield return new WaitForSeconds(delay);
        anim.SetBool("Skip", true);
    }

    IEnumerator WaitToFade()
    {
        canSkip = false;
        anim.SetBool("Skip", false);
        anim.enabled = true;
        sfx.Play();
        yield return new WaitForSeconds(1f);
        canSkip = true;
        yield return new WaitForSeconds(delay);
        anim.SetBool("Skip", true);
    }

    IEnumerator SkippingText()
    {
        canSkip = false;
        yield return new WaitForSeconds(1);
        canSkip = true;
    }

    IEnumerator disableMessage()
    {
        anim.SetBool("Skip", true);
        canSkip = false;
        yield return new WaitForSeconds(1);
        canSkip = true;
        parent.SetActive(false);
    }

    public void MarkerFound()
    {
        StopCoroutine("SkippingText");
        StopCoroutine("WaitToFade");

        StartCoroutine("disableMessage");
    }
}
