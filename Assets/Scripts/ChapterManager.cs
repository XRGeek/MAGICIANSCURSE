using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class ChapterManager : MonoBehaviour
{
    int[] chapterList;
    //  0: Main Menu
    //  1: Intro card, Hat & dove, Book & Book Key
    //  2: Chapter 1 content, Wall frame with tone, Eye of Music
    //  3: Chapter 2 Sand puzzle, , Eye of elements
    //  4: Chapter 3 Magic staff, elements, Potions, Black box, Eye of cosmos
    //  5: Chapter 4 Scale, Vibro puzzle, Eye of Ornaments
    //  6: Chapter 5 Card house and dices, Eye of Portals
    //  7: Chapter 6 Gems, 2 Key portals
    //  8: Chapter 7 Curse Key Eye Markers
    int currentChapter = 0;
    [SerializeField]
    private Button[] chapterBtns;
    [SerializeField]
    private GameObject[] LoadingRunes;
    private Animator[] animBtns;
    [SerializeField]
    private Puzzle[] puzzleList;
    [SerializeField]
    GameObject chaptersPanel;

    void Start()
    {
        animBtns = new Animator[chapterBtns.Length];
        for (int i = 0; i < chapterBtns.Length; i++)
        {
            animBtns[i] = chapterBtns[i].GetComponent<Animator>();
            chapterBtns[i].GetComponent<Lovatto.SceneLoader.bl_ButtonSceneLoad>().ResetInteractable();
        }
        SetPuzzleList();
    }

    private void SetPuzzleList()
    {
        puzzleList = new Puzzle[27];
        puzzleList[0] = new Puzzle("IT_Intro_Card", false);
        puzzleList[1] = new Puzzle("IT_Hat", false);
        puzzleList[2] = new Puzzle("IT_Book", false);
        puzzleList[3] = new Puzzle("IT_Key", false);
        //_____________________________________________________________
        puzzleList[4] = new Puzzle("IT_Eye_of_Music", false);
        //_____________________________________________________________
        puzzleList[5] = new Puzzle("IT_Eye_of_Elements", false);
        puzzleList[6] = new Puzzle("IT_Music_Sand_Cards", false);
        //_____________________________________________________________
        puzzleList[7] = new Puzzle("IT_Eye_of_Cosmos", false);
        puzzleList[8] = new Puzzle("IT_Puzzle_Cosmos_Cube", false);
        puzzleList[9] = new Puzzle("IT_Potion_Ice", false);
        puzzleList[10] = new Puzzle("IT_Potion_Fire", false);
        puzzleList[11] = new Puzzle("IT_Potion_Nature", false);
        puzzleList[12] = new Puzzle("IT_Potion_Wind", false);       
        //_____________________________________________________________
        puzzleList[13] = new Puzzle("IT_Eye_of_Ornaments", false);
        puzzleList[14] = new Puzzle("IT_Vibro_Puzzle", false);
        puzzleList[15] = new Puzzle("IT_Scale", false);
        //_____________________________________________________________
        puzzleList[16] = new Puzzle("IT_Eye_of_Portals", false);
        puzzleList[17] = new Puzzle("IT_Card_House", false);
        //_____________________________________________________________
        puzzleList[18] = new Puzzle("IT_Portal_Crown_Key_Part_1", false);
        puzzleList[19] = new Puzzle("IT_Portal_Crown_Key_Part_2", false);
        puzzleList[20] = new Puzzle("IT_Gem_01", false);
        puzzleList[21] = new Puzzle("IT_Gem_02", false);
        puzzleList[22] = new Puzzle("IT_Gem_03", false);
        puzzleList[23] = new Puzzle("IT_Gem_04", false);
        puzzleList[24] = new Puzzle("IT_Gem_05", false);
        puzzleList[25] = new Puzzle("IT_Gem_06", false);
        //_____________________________________________________________
        puzzleList[26] = new Puzzle("IT_Eye_Door_Part_03", false);
    }

    public void LoadChapter(int newChapter)
    {
        currentChapter = newChapter;
        for (int i = 0; i < chapterBtns.Length; i++)
        {
            chapterBtns[i].interactable = true;
            chapterBtns[i].GetComponent<Lovatto.SceneLoader.bl_ButtonSceneLoad>().ResetInteractable();
            LoadingRunes[i].SetActive(false);
        }
        chapterBtns[newChapter].interactable = false; 
        LoadingRunes[newChapter].SetActive(true);
    }

    public void UpdatePuzzle(string name, bool state)
    {
        for (int i = 0; i < puzzleList.Length; i++)
        {
            if (puzzleList[i].Name == name)
                puzzleList[i].Solved = state;
        }
    }

    public bool IsPuzzleSolved(string name)
    {
        for (int i = 0; i < puzzleList.Length; i++)
        {
            if (puzzleList[i].Name == name)
                return puzzleList[i].Solved;
        }

        return false;
    }

    public void LoadScenePuzzles()
    {
        //animBtns[currentChapter].SetBool("On", true);

        switch(currentChapter)
        {
            case 0:
                GameObject.Find("IT_Intro_Card").GetComponentInChildren<IntroCardState>(true).solved = puzzleList[0].Solved;
                GameObject.Find("IT_Hat").GetComponentInChildren<DoveSetPosition>(true).solved = puzzleList[1].Solved;
                GameObject.Find("IT_Book").GetComponentInChildren<BookController>(true).solved = puzzleList[2].Solved;
                GameObject.Find("IT_Key").GetComponentInChildren<BookKeyBehaviour>(true).solved = puzzleList[3].Solved;
                break;
                
            case 1:
                GameObject.Find("IT_Eye_of_Music").GetComponentInChildren<DigitalDisplay>(true).solved = puzzleList[4].Solved; 
                break;

            case 2:
                GameObject.Find("IT_Eye_of_Elements").GetComponentInChildren<DigitalDisplay>(true).solved = puzzleList[5].Solved; 
                GameObject.Find("IT_Music_Sand_Cards").GetComponentInChildren<MusicSandCardPuzzle>(true).solved = puzzleList[6].Solved; 
                break;

            case 3:
                GameObject.Find("IT_Eye_of_Cosmos").GetComponentInChildren<DigitalDisplay>(true).solved = puzzleList[7].Solved; 
                GameObject.Find("IT_Puzzle_Cosmos_Cube").GetComponentInChildren<Puzzle_3_Behaviour>(true).solved = puzzleList[8].Solved; 
                GameObject.Find("IT_Potion_Ice").GetComponentInChildren<PotionBehaviour>(true).solved = puzzleList[9].Solved; 
                GameObject.Find("IT_Potion_Fire").GetComponentInChildren<PotionBehaviour>(true).solved = puzzleList[10].Solved; 
                GameObject.Find("IT_Potion_Nature").GetComponentInChildren<PotionBehaviour>(true).solved = puzzleList[11].Solved; 
                GameObject.Find("IT_Potion_Wind").GetComponentInChildren<PotionBehaviour>(true).solved = puzzleList[12].Solved; 
                break;

            case 4:
                GameObject.Find("IT_Eye_of_Ornaments").GetComponentInChildren<DigitalDisplay>(true).solved = puzzleList[13].Solved; 
                GameObject.Find("IT_Vibro_Puzzle").GetComponentInChildren<Vibro_Pyramid_Puzzle>(true).solved = puzzleList[14].Solved; 
                GameObject.Find("IT_Scale").GetComponentInChildren<ScaleBehaviour>(true).solved = puzzleList[15].Solved;                
                break;

            case 5:
                GameObject.Find("IT_Eye_of_Portals").GetComponentInChildren<DigitalDisplay>(true).solved = puzzleList[16].Solved;
                GameObject.Find("IT_Card_House").GetComponentInChildren<CardHousePuzzle>(true).solved = puzzleList[17].Solved;                
                break;

            case 6:
                //GameObject.Find("IT_Portal_Crown_Key_Part_1").GetComponentInChildren<Crown_Key_Puzzle_Part>(true).solved = puzzleList[18].Solved; 
                //GameObject.Find("IT_Portal_Crown_Key_Part_2").GetComponentInChildren<Crown_Key_Puzzle_Part>(true).solved = puzzleList[19].Solved; 
                //GameObject.Find("IT_Gem_01").GetComponentInChildren<GemBehaviour>(true).solved = puzzleList[20].Solved; 
                //GameObject.Find("IT_Gem_02").GetComponentInChildren<GemBehaviour>(true).solved = puzzleList[21].Solved; 
                //GameObject.Find("IT_Gem_03").GetComponentInChildren<GemBehaviour>(true).solved = puzzleList[22].Solved; 
                //GameObject.Find("IT_Gem_04").GetComponentInChildren<GemBehaviour>(true).solved = puzzleList[23].Solved; 
                //GameObject.Find("IT_Gem_05").GetComponentInChildren<GemBehaviour>(true).solved = puzzleList[24].Solved; 
                //GameObject.Find("IT_Gem_06").GetComponentInChildren<GemBehaviour>(true).solved = puzzleList[25].Solved;
                break;

            case 7:
                GameObject.Find("IT_Eye_Door_Part_03").GetComponentInChildren<CrownKeyCompletion>(true).solved = puzzleList[26].Solved; ;
                break;
        }
    }
}

public class Puzzle
{
    public string Name { get; set; }
    public bool Solved { get; set; }

    public Puzzle(string name, bool solved)
    {
        Name = name;
        Solved = solved;
    }
}