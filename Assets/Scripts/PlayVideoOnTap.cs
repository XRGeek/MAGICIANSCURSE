using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayVideoOnTap : MonoBehaviour
{
    [SerializeField]
    private GameObject vPlayer;
    [SerializeField]
    private Animator dove;
    private Animator anim;

    [SerializeField]
    float waitTime = 4f;
    private AudioSource audioDove;
    [SerializeField]
    private AudioClip Flight_Clip;


    void Start()
    {
        audioDove = dove.GetComponent<AudioSource>();
        gameObject.GetComponent<Button>().onClick.AddListener(ButtonClicked);
        anim = GetComponent<Animator>();
    }

    private void ButtonClicked()
    {
        anim.SetBool("Pressed", true);
        StartCoroutine("AnimWait");
    }


    IEnumerator AnimWait()
    {
        yield return new WaitForSeconds(waitTime);
        audioDove.clip = Flight_Clip;
        audioDove.Play();

        dove.SetBool("takeoff", true);
        dove.SetBool("idle", false);
        dove.SetBool("falling", false);
        vPlayer.SetActive(true);
        yield return new WaitForSeconds(2f);
        dove.gameObject.SetActive(false);

    }
}
