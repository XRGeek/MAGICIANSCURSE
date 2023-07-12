using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class CardSlot : MonoBehaviour, IDropHandler
{
    [SerializeField]
    RectTransform correctCard;
    [SerializeField]
    MusicSandCardPuzzle mSCP;
    [SerializeField]
    int pID;

    public void OnDrop(PointerEventData eventData)
    {
        Debug.Log("OnDrop");
        if(eventData.pointerDrag != null)
        {
            RectTransform currentCard = eventData.pointerDrag.GetComponent<RectTransform>();
            currentCard.anchoredPosition = GetComponent<RectTransform>().anchoredPosition;

            if (currentCard == correctCard)
                mSCP.UpdateCards(pID - 1, true);
            else
            {
                mSCP.UpdateCards(pID - 1, false);
            }
            currentCard.gameObject.GetComponent<DragDrop>().AssignSlot(this);
        }
    }

    public void EmptySlot()
    {
        mSCP.UpdateCards(pID - 1, false);
    }
}
