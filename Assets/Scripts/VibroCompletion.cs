using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Vuforia;

public class VibroCompletion : MonoBehaviour
{
    private bool marker_01;
    [SerializeField]
    private bool marker_02;
    [SerializeField]
    private GameObject IT_01;
    [SerializeField]
    private GameObject IT_02;
    [SerializeField]
    private GameObject Puzzle_Vibro;

    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if (solved)
        {
            IT_01.SetActive(false);
            IT_02.SetActive(false);
            Puzzle_Vibro.SetActive(true);
        }
    }
    void Start()
    {
        marker_01 = false;
        marker_02 = false;
    }

    void Update()
    {
        if (solved)
            return;

        if (marker_01 == true && marker_02 == true)
        {
            IT_01.SetActive(false);
            IT_02.SetActive(false); 
            Puzzle_Vibro.SetActive(true);
            SolvePuzzle();
        }
    }
    public void EnableMarker_01()
    { marker_01 = true; }
    public void DisableMarker_01()
    { marker_01 = false; }
    public void EnableMarker_02()
    { marker_02 = true; }
    public void DisableMarker_02()
    { marker_02 = false; }
    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }
}
