using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CallLastMessage : MonoBehaviour
{
    [SerializeField]
    private GameObject msg;
    private Animator anim;
    private bool solved;

    private void OnEnable()
    {
        if(anim != null)
            anim.SetBool("Solved", solved);
    }

    private void Start()
    {
        solved = false;
        anim = GetComponent<Animator>();
    }
    public void CallMessage()
    {
        solved = true;
        msg.SetActive(true);
    }
}
