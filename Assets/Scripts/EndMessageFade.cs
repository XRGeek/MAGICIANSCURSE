using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EndMessageFade : MonoBehaviour
{
    Animator anim;
    [SerializeField]
    float startDelay = 8f;
    [SerializeField]
    float vPlayerDelay = 20f;
    [SerializeField]
    private GameObject parent;
    private AudioSource sfx;
    [SerializeField]
    private GameObject vPlayer;


    void Start()
    {
        anim = GetComponent<Animator>();
        sfx = parent.GetComponent<AudioSource>();
        anim.enabled = false;
        StartCoroutine("StartWaitToFade");
    }

    IEnumerator StartWaitToFade()
    {
        anim.SetBool("Skip", false);
        anim.enabled = false;
        yield return new WaitForSeconds(startDelay);
        anim.enabled = true;
        sfx.Play();
        yield return new WaitForSeconds(1f);
        vPlayer.SetActive(true);
        yield return new WaitForSeconds(vPlayerDelay);
        anim.SetBool("Skip", true);
        vPlayer.SetActive(false);

    }
}
