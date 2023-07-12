﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeBool_ASB : StateMachineBehaviour
{    
    public string boolName;
    public bool status;
    public bool resetOnExit;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.SetBool(boolName, status);
    }
    
    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (resetOnExit)        
            animator.SetBool(boolName, !status);        
    }

}
