using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeFloat_ASB : StateMachineBehaviour
{    
    public string floatName;
    public float value;
    public bool addSelfValue;
    public bool resetOnExit;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (addSelfValue)
        {
            float selfValue = animator.GetFloat(floatName);
            animator.SetFloat(floatName, selfValue + value);
        }
        else 
            animator.SetFloat(floatName, value);

    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (resetOnExit)        
            animator.SetFloat(floatName, 0.0f);        
    }

}
