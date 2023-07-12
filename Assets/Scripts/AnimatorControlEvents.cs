using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorControlEvents : MonoBehaviour
{
    Animator anim;
    bool introPlayed = false;

    private void OnEnable()
    {
        if (anim == null)
        {
            anim = GetComponent<Animator>();
        }
        anim.SetBool("IntroPlayed", introPlayed);

    }
    void Start()
    {
        anim = GetComponent<Animator>();
    }

    public void DisableAnim()
    { anim.enabled = false; }

    public void HasPlayedOnce()
    { introPlayed = true; }
}
