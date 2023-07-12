using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class TarotCardInteractions : MonoBehaviour
{
    [SerializeField]
    private Transform card;
    private bool canInteract;
    [SerializeField]
    private DiceBehaviour selectedDice;
    private SwitchUIHelper sUIHelper;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////


    private void OnEnable()
    {
        if (selectedDice != null)
        {
            selectedDice.ChangeSelectState(false);
            selectedDice.interactable = false;
            selectedDice = null;
        }

        if (sUIHelper == null)
            sUIHelper = GetComponent<SwitchUIHelper>();

        sUIHelper.canSwitchHelper = false;
        GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(1);
        StartCoroutine("WaitForLerp");
    }

    private void Start()
    {
        sUIHelper = GetComponent<SwitchUIHelper>();
        canInteract = true;
    }

    private void Update()
    {
        if (!canInteract) return;

        if (selectedDice != null)
        {
            if (!selectedDice.interactable)
                return;

            if (selectedDice.isDragged)
            {
                return;
            }
        }
        if (!canInteract)
            return;

        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, 100))
            {
                if (selectedDice != null)
                {
                    if (hit.transform == selectedDice.transform)
                    {
                        return;
                    }
                }

                if (hit.transform == card)
                {
                    sUIHelper.canSwitchHelper = false;
                    GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(2);
                    selectedDice = hit.transform.GetComponent<DiceBehaviour>();
                    selectedDice.ChangeSelectState(true);
                    selectedDice.interactable = false;
                }
                else
                {
                    if (selectedDice == null)
                        return;
                    else
                    {
                        sUIHelper.canSwitchHelper = false;
                        GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(1);
                        selectedDice.ChangeSelectState(false);
                        selectedDice.interactable = false;
                        selectedDice = null;
                    }
                }
            }
            else
            {
                if (selectedDice == null)
                    return;
                else
                {
                    sUIHelper.canSwitchHelper = false;
                    GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(1);
                    selectedDice.ChangeSelectState(false);
                    selectedDice.interactable = false;
                    selectedDice = null;
                }
            }
            StartCoroutine("WaitForLerp");
        }
    }
    private IEnumerator WaitForLerp()
    {
        canInteract = false;
        yield return new WaitForSeconds(1f);
        canInteract = true;
    }
}
