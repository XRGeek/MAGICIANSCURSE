using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class DragDrop : MonoBehaviour, IPointerDownHandler, IBeginDragHandler, IEndDragHandler, IDragHandler, IDropHandler
{
    [SerializeField] private Canvas myCanvas;
    private RectTransform rectT;
    private CanvasGroup canvasGroup;
    [SerializeField]
    private CardSlot currentSlot;

    [SerializeField]
    LayerMask layer;
    [SerializeField]
    private AudioClip[] dragDropSfx;
    private AudioSource sfx;

    [SerializeField]
    private Collider planeMesh;

    private void Awake()
    {
        rectT = GetComponent<RectTransform>();
        canvasGroup = GetComponent<CanvasGroup>();
        sfx = GetComponent<AudioSource>();
    }

    public void AssignSlot(CardSlot slotID)
    {
        currentSlot = slotID;
        sfx.Stop();
        sfx.clip = dragDropSfx[1];
        sfx.Play();
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        if (currentSlot != null)
        {
            currentSlot.EmptySlot();
            currentSlot = null;
        }
        canvasGroup.blocksRaycasts = false;
        canvasGroup.alpha = 0.6f;
    }

    public void OnDrag(PointerEventData eventData)
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 100))
        {
            transform.position = hit.point;
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        canvasGroup.blocksRaycasts = true;
        canvasGroup.alpha = 1f;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        sfx.Stop();
        sfx.clip = dragDropSfx[0];
        sfx.Play();
    //    planeMesh.enabled = true;
    }
    /*
    public void OnPointerUp(PointerEventData eventData)
    {
        planeMesh.enabled = false;
    }
    */
    public void OnDrop(PointerEventData eventData)
    {

    }
}

