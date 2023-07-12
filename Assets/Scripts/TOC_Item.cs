using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TOC_Item : MonoBehaviour
{
    public int Index = 0;

    void Start()
    {
        
    }
    public void GetChapter()
    {
        Debug.Log("TOC Pressed "+Index);
        TOC_Manager.Instance.OpenChapter(Index-1);
        TOC_Manager.Instance.TOC_manager();
        TOC_Manager.Instance.IsBusy = true;
    }
}
