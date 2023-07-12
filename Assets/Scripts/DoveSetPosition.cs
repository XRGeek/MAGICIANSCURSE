using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoveSetPosition : MonoBehaviour
{
    private Animator anim;

    [SerializeField]
    private Transform hatTarget;
    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if(solved)
        {
            if(!anim)
                anim = GetComponent<Animator>();
            anim.SetBool("idle", true);
            transform.position = hatTarget.position;
        }
        else
            StartCoroutine("WaitForLanding");
    }
    void Start()
    {
        anim = GetComponent<Animator>();
    }

    
    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }

    private IEnumerator WaitForLanding()
    {
        yield return new WaitForSeconds(3f);
        solved = true;
    }

}
