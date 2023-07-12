using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntroCardState : MonoBehaviour
{
    public bool solved = false;
    public string PuzzleName;
    public GameObject StartMessage;


    private void Update()
    {
        if (!solved)
            return;
        if (solved && StartMessage != null)
        {
            Destroy(StartMessage.gameObject);
        }
    }
    public void SolvePuzzle()
    {
        solved = true;
        var cm = FindObjectOfType<ChapterManager>();

        if (cm != null)
        {
            //solved = true;
            cm.UpdatePuzzle(PuzzleName, true);
        }
        
    }
}