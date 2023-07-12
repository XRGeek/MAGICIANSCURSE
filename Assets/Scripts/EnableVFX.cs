using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnableVFX : StateMachineBehaviour
{
    public bool status;
    //public bool resetOnExit;
    public GameObject GOMRupdater;
    private PSMeshRendererUpdater MRupdater;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        MRupdater = GOMRupdater.GetComponent<PSMeshRendererUpdater>();
        MRupdater.IsActive = status;
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        MRupdater = GOMRupdater.GetComponent<PSMeshRendererUpdater>();
        MRupdater.IsActive = status;

    }
}
