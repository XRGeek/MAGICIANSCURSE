using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Crown_Key_Puzzle_Part : MonoBehaviour
{
    private bool[] ppAngles;
    [SerializeField]
    Animator anim;
    int gemCount = 0;
    bool gemsReady = false;
    [SerializeField]
    GemBehaviour[] gems;
    private SwitchUIHelper sUIHelper;

    [SerializeField]
    private Crown_Key_Puzzle_Part otherPortal;
    [SerializeField]
    private ActivateMessageOnce SolvedMessageTrigger,firstMessageTrigger;


    public bool solved = false;
    public string PuzzleName;



    public static List<string> SolvedGemNames = new List<string>();


    private void DelayedEnable()
    {
        if (gemCount == 0)
            for (int i = 0; i < gems.Length; i++)
            {
                if (gems[i].solved)
                {
                    gems[i].TPGem();
                    gemCount++;
                }
            }


        if (gemCount == 3)
        {
            if (!gemsReady)
            {
                sUIHelper.canSwitchHelper = true;
                GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(1);
                gemsReady = true;
                //for (int i = 0; i < gems.Length; i++)
                //{
                //    gems[i].TPGem();
                //}
                anim.enabled = true;
            }
        }

        if (solved)
        {
            Crown_Key_Puzzle_Button[] btns = GetComponentsInChildren<Crown_Key_Puzzle_Button>();
           
         

            if (!sUIHelper)
                sUIHelper = GetComponent<SwitchUIHelper>();

            anim.enabled = true;
            anim.SetBool("Solved", true);
            GetComponent<SwitchUIHelper>().canSwitchHelper = false;
            sUIHelper.canSwitchHelper = false;
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);

            foreach (Crown_Key_Puzzle_Button btn in btns)
            {
                btn.PutThemRight();
                btn.enabled = false;
            }

            return;
        }

        firstMessageTrigger.ActivateOnce();
    }

    private void OnEnable()
    {

        var chM = FindObjectOfType<ChapterManager>();
        if (chM != null)
            solved = chM.IsPuzzleSolved(PuzzleName);

        Invoke("DelayedEnable", 0.2f);
        Debug.Log("Crown_Key_Puzzle_Part Solved");

      
    }

    private void Start()
    {
        sUIHelper = GetComponent<SwitchUIHelper>();
        ppAngles = new bool[4];
        for (int i = 0; i < ppAngles.Length; i++)
        {
            ppAngles[i] = false;
        }
    }

    public void AddGem(string gemName)
    {

        if (SolvedGemNames.Contains(gemName))
            return;


        SolvedGemNames.Add(gemName);

        gemCount++;
    }

    public void UpdateAngles(int pID, bool state)
    {
        ppAngles[pID] = state;
    }
    
    void Update()
    {
        if(solved)        
            return;
        
        if (gemCount == 3)
        {
            if(!gemsReady)
            {
                sUIHelper.canSwitchHelper = true;
                GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(1);

                anim.enabled = true;
                gemsReady = true;
            }
        }
        if (isPuzzleComplete())
        {
            anim.enabled = true;
            anim.SetBool("Solved", true);
            GetComponent<SwitchUIHelper>().canSwitchHelper = false;
            sUIHelper.canSwitchHelper = false;
            GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
            Crown_Key_Puzzle_Button[] btns = GetComponentsInChildren<Crown_Key_Puzzle_Button>();
            foreach (Crown_Key_Puzzle_Button btn in btns)
                btn.enabled = false;

            SolvePuzzle();
        }
    }
    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);

        if (otherPortal.solved)
        {
            SolvedMessageTrigger.ActivateOnce();
        }
    }

    private bool isPuzzleComplete()
    {
        for (int i = 0; i < ppAngles.Length; i++)
        {
            if (ppAngles[i] == false)
            {
                return false;
            }
        }
        return true;
    }
}
