using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TarotCardMeshUpdate : MonoBehaviour
{
    [SerializeField]
    private MeshRenderer[] cardsides;
    [SerializeField]
    private Material m_German;
    [SerializeField]
    private Material m_French;
    [SerializeField]
    private Material m_English;


    void Start()
    {
        switch (GleyLocalization.Manager.GetCurrentLanguage().ToString())
        {
            // English
            case "English":
                for (int i = 0; i < cardsides.Length; i++)                
                    cardsides[i].material = m_English;    
                break;
            // French
            case "French":
                for (int i = 0; i < cardsides.Length; i++)
                    cardsides[i].material = m_French;
                break;
            // German
            case "German":
                for (int i = 0; i < cardsides.Length; i++)
                    cardsides[i].material = m_German; 
                break;
        }
    }

}
