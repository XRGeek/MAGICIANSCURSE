using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class TOC_Manager : MonoBehaviour
{
    public static TOC_Manager Instance;

    public Image TOC_ImageENG;
    public Image TOC_ImageGER;
    //public Image TOC_Image;
    public BookController bookController;
    public bool IsBusy = false;

    public Image TOC_Image;
    private string Language = "";
    private bool IsTOC_Enabled = false;


    private void Awake()
    {
        if (Instance!=null)
        {
            Destroy(gameObject);
        }
        else
        {
            Instance = this;
        }
    }
    private void Start()
    {
        Language = GleyLocalization.Manager.GetCurrentLanguage().ToString();
        Debug.Log("Language "+ Language);
        if (Language == "German")
        {
            TOC_ImageENG.gameObject.SetActive(false);
            TOC_ImageGER.gameObject.SetActive(true);
            TOC_Image = TOC_ImageGER;
        }
        else
        {
            TOC_ImageENG.gameObject.SetActive(true);
            TOC_ImageGER.gameObject.SetActive(false);
            TOC_Image = TOC_ImageENG;
        }
    }
    public void TOC_manager()
    {
        if (!IsTOC_Enabled)
        {
            TOC_Image.transform.DOScale(1, 0.6f).SetEase(Ease.OutBack);
            IsTOC_Enabled = true;
        }
        else
        {
            TOC_Image.transform.DOScale(0, 0.6f).SetEase(Ease.InBack);
            IsTOC_Enabled = false;
        }
    }
    public void OpenChapter(int index)
    {
        bookController.GetChapter_(index);
    }
    public void Next()
    {
        if (!IsBusy)
        {
            bookController.MoveNext();
            IsBusy = true;
            StartCoroutine(WaitTillBusy());
        }
    }
    public void Back()
    {
        if (!IsBusy)
        {
            bookController.MoveBack();
            IsBusy = true;
            StartCoroutine(WaitTillBusy());
        }
    }
    IEnumerator WaitTillBusy()
    {
        yield return new WaitForSeconds(1.53f);
        IsBusy = false;
    }
}
