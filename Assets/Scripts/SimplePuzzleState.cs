using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimplePuzzleState : MonoBehaviour
{
    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if (solved)
            gameObject.SetActive(false);
    }

    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }
}
