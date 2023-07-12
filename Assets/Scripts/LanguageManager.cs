using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LanguageManager : MonoBehaviour
{

    public Dropdown LanguageSelect;
    [SerializeField]
    bl_LoadingScreenUI loadingScreenUI;


    private static SupportedLanguages lastLanguel=0;
    private void Start()
    {
        Debug.Log("lastLanguel:"+lastLanguel);
        if (lastLanguel != 0)
        {
            
            GleyLocalization.Manager.SetCurrentLanguage(lastLanguel);

            switch (GleyLocalization.Manager.GetCurrentLanguage())
            {
                case SupportedLanguages.English:
                    LanguageSelect.SetValueWithoutNotify(0);
                    break;
                case SupportedLanguages.French:
                    LanguageSelect.SetValueWithoutNotify(2);
                    break;
                case SupportedLanguages.German:
                    LanguageSelect.SetValueWithoutNotify(1);
                    break;
               
            }
            
        }
           
        else
        GleyLocalization.Manager.SetCurrentLanguage(SupportedLanguages.English);


        
    }

    public void UpdateText()
    {
        switch (LanguageSelect.options[LanguageSelect.value].text)
        {
            case "English":
                GleyLocalization.Manager.SetCurrentLanguage(SupportedLanguages.English);
                lastLanguel = SupportedLanguages.English;
                break;
            case "Français":
                GleyLocalization.Manager.SetCurrentLanguage(SupportedLanguages.French);
                lastLanguel = SupportedLanguages.French;
                break;
            case "Deutsch":
                GleyLocalization.Manager.SetCurrentLanguage(SupportedLanguages.German);
                lastLanguel = SupportedLanguages.German;
                break;
            case "EN":
                GleyLocalization.Manager.SetCurrentLanguage(SupportedLanguages.English);
                lastLanguel = SupportedLanguages.English;
                break;
            case "FR":
                GleyLocalization.Manager.SetCurrentLanguage(SupportedLanguages.French);
                lastLanguel = SupportedLanguages.French;
                break;
            case "DE":
                GleyLocalization.Manager.SetCurrentLanguage(SupportedLanguages.German);
                lastLanguel = SupportedLanguages.German;
                break;
        }
        loadingScreenUI.ChangeTipsLanguage();
    }

}
