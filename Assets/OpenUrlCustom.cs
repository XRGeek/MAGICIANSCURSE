using System.Collections;
using System.Collections.Generic;
using GleyLocalization;
using UnityEngine;
using UnityEngine.SceneManagement;

public class OpenUrlCustom : MonoBehaviour
{


    public void OpenUrlLocal(int wordID)
    {
        var wid = (WordIDs) wordID;
        var link = LocalizationManager.Instance.GetText(wid);
        Debug.Log(link);
        Application.OpenURL(link);
    }

    public void OpenUrl(string link)
    {
        Debug.Log(link);
        Application.OpenURL(link);
    }

    public void OpenScene(string name)
    {
        SceneManager.LoadScene(name);
    }

}
