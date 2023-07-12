using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class BookController : MonoBehaviour
{
    Animator anim;
    public bool open;
    public bool opening;
    //public bool pageOnTheRight;
    private int turningPagesAmount = 14;
    public int currentPages = 0;
    public bool close;
    private bool gotBookKey = false;
    private bool EnableRaycast = false;

    public PSMeshRendererUpdater[] PSMRUpdater;
    private Material[] pageMat;
    [SerializeField]
    private Material[] pageMat_English;
    [SerializeField]
    private Material[] pageMat_German;
    [SerializeField]
    private Material[] pageMat_French;
    [SerializeField]
    private SkinnedMeshRenderer[] pageMesh;
    [SerializeField]
    private AudioClip[] sfxClips;
    private AudioSource sfx;

    public bool solved = false;
    public string PuzzleName;

    [SerializeField]
    private GameObject TOC_Panel;
    //private GameObject[] TableOfContentColliders;
    [SerializeField]
    private Button[] TOC_Buttons;
    //[SerializeField]
    //private GameObject OpenBookBtn;
    [SerializeField]
    private GameObject TOC_Button;

    private void OnEnable()
    {
        if(!sfx)
            sfx = GetComponent<AudioSource>();
        if (!anim)
            anim = GetComponent<Animator>();

        if (solved)
        {
              if (currentPages > 0)
                for (int i = 0; i < pageMesh.Length; i++)
                {
                    pageMesh[i].material = pageMat[i + (2 * (currentPages - 1))];
                }

            GetBookKey();
        }
    }

    private void Awake()
    {
        SetLanguage();
    }
    void Start()
    {
        sfx = GetComponent<AudioSource>();
        anim = GetComponent<Animator>();
        open = false;
        opening = false;
        //pageOnTheRight = true;
        close = false;

        for (int i = 0; i < PSMRUpdater.Length; i++)
            PSMRUpdater[i].IsActive = false;

        SetLanguage();
        //TurnOffColliders(TableOfContentColliders, false);
    }

    public LayerMask mask;
    private bool isBusy = false;
    void Update()
    {



        if(!open)
        {
            opening = false;
            close = false;
        }
        opening = anim.GetBool("opening");
        //Debug.Log("opening " + opening);
        if (!gotBookKey || opening)
            return;

        if (Input.GetMouseButtonDown(0))
        {
            if (isBusy)
                return;


            if (EnableRaycast)
            {
                Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                RaycastHit hitObject;
                if (Physics.Raycast(ray, out hitObject, mask))
                {
                    Debug.Log("Raycast... Hit=" + hitObject.transform.name);
                    if (hitObject.transform.name == "Book_Collider_R")
                    {

                        currentPages--;

                        Debug.Log(currentPages + "=Raycast... Book_Collider_R");

                        //if (currentPages == 0)
                        //{
                        //    //TurnOffColliders(TableOfContentColliders,true);
                        //    //StartCoroutine(TOC_WaitManager(0.8f, true));
                        //    //Move_Back.SetActive(false);
                        //}

                        if (currentPages >= turningPagesAmount)
                        {
                            Debug.Log("1");
                            CloseBook();
                            currentPages = turningPagesAmount;
                        }
                        else if (currentPages < 0)
                        {
                            Debug.Log("2");
                            OpenBook();
                            currentPages = 0;
                        }
                        else
                        {
                            Debug.Log("3");
                            TurnPrevPage();
                            //pageOnTheRight = true;
                        }

                        //if (currentPages==0)
                        //{
                        //    //TurnOffColliders(TableOfContentColliders,true);
                        //    StartCoroutine(TOC_WaitManager(0.8f, true));
                        //    //Move_Back.SetActive(false);
                        //    StartCoroutine(DisableBackBtn(false, 0.8f));
                        //}
                    }
                    else if (hitObject.transform.name == "Book_Collider_L")
                    {
                        currentPages++;
                        Debug.Log(currentPages + "=Raycast... Book_Collider_L");
                        if (currentPages >= turningPagesAmount)
                        {
                            if (!close)
                            {
                                Debug.Log("4");
                                CloseBook();
                                currentPages = turningPagesAmount;
                            }

                            else
                            {
                                Debug.Log("5");
                                EnableRaycast = false;
                                StartCoroutine(TOC_WaitManager(2.4f, true));
                                CloseBook();

                                currentPages = turningPagesAmount - 1;
                            }


                        }
                        else if (currentPages <= 0)
                        {
                            Debug.Log("6");
                            OpenBook();
                            currentPages = 0;
                        }
                        else
                        {
                            Debug.Log("6");
                            TurnNextPage();
                            //pageOnTheRight = false;
                        }
                        //if (currentPages >= 1)
                        //{
                        //    //TurnOffColliders(TableOfContentColliders, false);
                        //    //StartCoroutine(TOC_WaitManager(0.8f, false));
                        //    //Move_Back.SetActive(true);
                        //    //StartCoroutine(DisableBackBtn(true, 0.8f));
                        //}
                    }
                    //    else if (hitObject.transform.tag == "Back")
                    //    {
                    //        BackToTableOfContent();
                    //    }



                    //else if (hitObject.transform.tag == "Chapter_0")
                    //{
                    //    Debug.Log("Move to Chapter_0");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(-1));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_1")
                    //{
                    //    Debug.Log("Move to Chapter_1");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(0));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_2")
                    //{
                    //    Debug.Log("Move to Chapter_2");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(1));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_3")
                    //{
                    //    Debug.Log("Move to Chapter_3");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(2));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_4")
                    //{
                    //    Debug.Log("Move to Chapter_4");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(3));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_5")
                    //{
                    //    Debug.Log("Move to Chapter_5");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(4));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_6")
                    //{
                    //    Debug.Log("Move to Chapter_6");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(5));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_7")
                    //{
                    //    Debug.Log("Move to Chapter_7");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(6));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_8")
                    //{
                    //    Debug.Log("Move to Chapter_8");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(7));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_9")
                    //{
                    //    Debug.Log("Move to Chapter_9");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(8));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_10")
                    //{
                    //    Debug.Log("Move to Chapter_10");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(9));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_11")
                    //{
                    //    Debug.Log("Move to Chapter_11");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(10));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_12")
                    //{
                    //    Debug.Log("Move to Chapter_12");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(11));
                    //}
                    //else if (hitObject.transform.tag == "Chapter_13")
                    //{
                    //    Debug.Log("Move to Chapter_13");
                    //    MoveNext();
                    //    StartCoroutine(TOC_WaitManager(0.8f, false));
                    //    StartCoroutine(WaitToMoveNext(12));
                    //}
                }
            }
        }
    }
        



        //Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        //RaycastHit hitObject;
        //if (Physics.Raycast(ray, out hitObject, mask))
        //{
        //    Debug.Log("Raycast... Hit=" + hitObject.transform.name);
        //    if (hitObject.transform.name == "Book_Collider_R")
        //    {

        //        currentPages--;

        //        Debug.Log(currentPages + "=Raycast... Book_Collider_R");
        //        if (currentPages >= turningPagesAmount)
        //        {
        //            CloseBook();
        //            currentPages = turningPagesAmount;
        //        }
        //        else if (currentPages < 0)
        //        {
        //            OpenBook();
        //            currentPages = 0;
        //        }
        //        else
        //        {
        //            TurnPrevPage();
        //            //pageOnTheRight = true;
        //        }
        //    }
        //    else if (hitObject.transform.name == "Book_Collider_L")
        //    {
        //        currentPages++;
        //        Debug.Log(currentPages + "=Raycast... Book_Collider_L");
        //        if (currentPages >= turningPagesAmount)
        //        {
        //            if (!close)
        //            {
        //                CloseBook();
        //                currentPages = turningPagesAmount;
        //            }

        //            else
        //            {
        //                CloseBook();
        //                currentPages = turningPagesAmount - 1;
        //            }


        //        }
        //        else if (currentPages <= 0)
        //        {
        //            OpenBook();
        //            currentPages = 0;
        //        }
        //        else
        //        {
        //            TurnNextPage();
        //            //pageOnTheRight = false;
        //        }
        //    }
        //}
    
    public void GetChapter_(int index)
    {
        int Difference = 0;
        Debug.Log("Move to Chapter "+ index);
        //MoveNext();
        ////StartCoroutine(TOC_WaitManager(0.8f, false));
        //StartCoroutine(WaitToMoveNext((index-1)));

        if (currentPages > (index))
        {
            Debug.Log("currentPages " + currentPages);
            Debug.Log("index  " + index );
            Debug.Log("Difference "+ (currentPages - index ));
            //MoveBack();
            Difference = currentPages - index;
            StartCoroutine(MoveToBackChapter(Difference-1));
            //StartCoroutine(WaitToMoveBack(index - 1));
        }
        else
        {
            Difference = index - currentPages;
            //MoveNext();
            //StartCoroutine(TOC_WaitManager(0.8f, false));
            //StartCoroutine(WaitToMoveNext((index - 1)));
            StartCoroutine(WaitToMoveNext((Difference )));
        }
    }
    //private void BackToTableOfContent()
    //{
    //    MoveBack();
    //    StartCoroutine(WaitToMoveBack());
    //}
    IEnumerator WaitToMoveBack()
    {
        yield return new WaitForSeconds(1.51f);
        if (currentPages > 0)
        {
            MoveBack();
            StartCoroutine(WaitToMoveBack());
        }
    }
    public void TOC_Buttons_Manager(bool value)
    {
        foreach (Button button in TOC_Buttons)
        {
            button.interactable = value;
        }
    }
    public void EnableTOC_PanelOnTargetFound()
    {
        if (anim.GetBool("open"))
        {
            TOC_Panel.SetActive(true);
        }
        else
        {
            TOC_Panel.SetActive(false);
        }
    }
    public void MoveBack()
    {
        //Move_Back.SetActive(false);
        //StartCoroutine(DisableBackBtn(false,0.8f));

        currentPages--;

        Debug.Log(currentPages + " = MoveBack");
        if (currentPages >= turningPagesAmount)
        {
            CloseBook();
            currentPages = turningPagesAmount;
            //OpenBookBtn.SetActive(true);
            EnableRaycast = true;
            StartCoroutine(TOC_WaitManager(1, false));
        }
        else if (currentPages < 0)
        {
            OpenBook();
            currentPages = 0;
        }
        else
        {
            TurnPrevPage();
            //pageOnTheRight = true;
        }

        if (currentPages == 0)
        {
            TOC_Button.SetActive(true);
            //TurnOffColliders(TableOfContentColliders, true);
            //Move_Back.SetActive(false);
            //StartCoroutine(TOC_WaitManager(0.8f, true));
        }
    }
    IEnumerator MoveToBackChapter(int Iterations)
    {
        Debug.Log("Iterations "+ Iterations);
        yield return new WaitForSeconds(1.51f);
        if (Iterations > 0)
        {
            MoveBack();
            StartCoroutine(MoveToBackChapter(--Iterations));
        }
        else
        {
            TOC_Manager.Instance.IsBusy = false;
        }
    }
    IEnumerator WaitToMoveNext(int Iterations)
    {
        yield return new WaitForSeconds(1.51f);
        if (Iterations>=0)
        {
            MoveNext();
            StartCoroutine(WaitToMoveNext(--Iterations));
        }
        else
        {
            TOC_Manager.Instance.IsBusy = false;
        }
    }
    public void MoveNext()
    {
        //Move_Back.SetActive(true);
        //StartCoroutine(TOC_WaitManager(1.3f, false));
        currentPages++;
        Debug.Log(currentPages + " = MoveNext");
        if (currentPages >= turningPagesAmount)
        {
            if (!close)
            {
                Debug.Log("7");
                CloseBook();
                EnableRaycast = true;
                currentPages = turningPagesAmount;
                StartCoroutine(TOC_WaitManager(1, false));
            }

            else
            {
                Debug.Log("8");
                CloseBook();
                currentPages = turningPagesAmount - 1;
                StartCoroutine(TOC_WaitManager(1, false));
            }


        }
        else if (currentPages <= 0)
        {
            Debug.Log("9");
            OpenBook();
            currentPages = 0;
        }
        else
        {
            Debug.Log("10");
            //TOC_Button.SetActive(false);
            TurnNextPage();
            //pageOnTheRight = false;
        }
    }
    IEnumerator TOC_WaitManager(float Wait,bool value)
    {
        yield return new WaitForSeconds(Wait);
        TOC_Panel.SetActive(value);
        //TurnOffColliders(TableOfContentColliders, value);
    }
    //IEnumerator OpenBookBtnManager(float Wait, bool value)
    //{
    //    yield return new WaitForSeconds(Wait);
    //    //OpenBookBtn.SetActive(value);
    //    //TurnOffColliders(TableOfContentColliders, value);
    //}
    private void TurnOffColliders(GameObject[] Colliders,bool value)
    {
        foreach (GameObject Object in Colliders)
        {
            Object.SetActive(value);
        }
    }
    public void SetLanguage()
    {
        string Language = GleyLocalization.Manager.GetCurrentLanguage().ToString();
        pageMat = new Material[pageMat_English.Length];
        switch (Language)
        {
            case "English":
                for (int i = 0; i < pageMat_English.Length; i++)            
                    pageMat[i] = pageMat_English[i];                
                break;
            case "French":
                for (int i = 0; i < pageMat_French.Length; i++)
                    pageMat[i] = pageMat_French[i]; 
                break;
            case "German":
                for (int i = 0; i < pageMat_German.Length; i++)
                    pageMat[i] = pageMat_German[i]; 
                break;
        }

        for (int i = 0; i < pageMesh.Length; i++)
        {
            pageMesh[i].material = pageMat[i];
        }
    }
    public void OpenBook()
    {

        Debug.Log("OpenBook");
        //pageOnTheRight = true;
        if (!gotBookKey)
            return;

        //TurnOffColliders(TableOfContentColliders, false);
        open = !open;
        if(opening)
        {
            for (int i = 0; i < PSMRUpdater.Length; i++)
                PSMRUpdater[i].IsActive = true;
        }
        else
        {
            for (int i = 0; i < PSMRUpdater.Length; i++)
                PSMRUpdater[i].IsActive = false;
        }
        if(open)
        {
            StopCoroutine("PlayAudioDelayed");
            StartCoroutine(PlayAudioDelayed(4f, 0));
        }
        else
        {
            StopCoroutine("PlayAudioDelayed");
            StartCoroutine(PlayAudioDelayed(1f, 1));
        }

        anim.SetBool("open", open);
        Debug.Log("open dddd"+ open);
        
        if (open)
        {
            Debug.Log("open if");
            //Move_Back.SetActive(false);
            EnableRaycast = false;
            StartCoroutine(TOC_WaitManager(5.2f, true));
            //OpenBookBtn.SetActive(false);
        }
        else
        {
            //StartCoroutine(TOC_WaitManager(1, true));
            //TurnOffColliders(TableOfContentColliders, false);
            //StartCoroutine(TOC_WaitManager(0.8f, false));
            TOC_Panel.SetActive(false);
            EnableRaycast = true;
            //OpenBookBtn.SetActive(true);
            //StartCoroutine(OpenBookBtnManager(3.5f,true));
            Debug.Log("open else");
        }
    }

    public void TurnPrevPage()
    {
        if (isBusy)
        {
            TOC_Buttons_Manager(false);
            return;
        }
            

        isBusy = true;
        Invoke("NotBusy", 1.5f);
        Debug.Log("TurnPrevPage");

        StopCoroutine("PlayAudioDelayed");
        StartCoroutine(PlayAudioDelayed(0f, Random.Range(2, sfxClips.Length)));

        anim.SetTrigger("pageTurn_Left");

        //if (!pageOnTheRight)
        //    return;
        for (int i = 0; i < pageMesh.Length; i++)
        {
            pageMesh[i].material = pageMat[i + (2 * (currentPages))];
        }
    }

    public void TurnNextPage()
    {
        if (isBusy)
        {
            TOC_Buttons_Manager(false);
            return;
        }
            

        isBusy = true;
        Invoke("NotBusy",1.5f);
        Debug.Log("TurnNextPage");

        anim.SetTrigger("pageTurn_Right");

        StopCoroutine("PlayAudioDelayed");
        StartCoroutine(PlayAudioDelayed(0f, Random.Range(2, sfxClips.Length)));

        //if (pageOnTheRight)
        //    return;
        for (int i = 0; i < pageMesh.Length; i++)
        {
            pageMesh[i].material = pageMat[i + (2 * (currentPages-1))];
        }
    }

    private void NotBusy()
    {
        isBusy = false;
        TOC_Buttons_Manager(true);
    }

    public void CloseBook()
    {
        Debug.Log("CloseBook");

        close = !close;
        //pageOnTheRight = false;
        //StartCoroutine(TOC_WaitManager(1, false));
        TOC_Panel.SetActive(false);
        //OpenBookBtn.SetActive(true);
        anim.SetBool("close", close);
        if (close)
        {
            StopCoroutine("PlayAudioDelayed");
            StartCoroutine(PlayAudioDelayed(1f, 1));
        }
        else
        {
            StopCoroutine("PlayAudioDelayed");
            StartCoroutine(PlayAudioDelayed(0.5f, 0));
        }
    }

    public void GetBookKey()
    {
        SolvePuzzle();
        gotBookKey = true;

        Debug.Log("gotBookKey "+ gotBookKey);
        if(!open)
        OpenBook();

        GetComponent<SwitchUIHelper>().canSwitchHelper = true;
        GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(1);
    }
    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }
    private IEnumerator PlayAudioDelayed(float delay, int clipID)
    {
        yield return new WaitForSeconds(delay);
        sfx.clip = sfxClips[clipID];
        sfx.Play();
    }
}


