using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardHousePuzzle : MonoBehaviour
{
    Animator anim;

    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if(solved)
        {
            if (!anim)
                anim = GetComponent<Animator>();
            anim.SetBool("Solved", true);
        }
    }


    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }
}
