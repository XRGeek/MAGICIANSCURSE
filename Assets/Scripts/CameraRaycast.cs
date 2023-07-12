using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CameraRaycast : MonoBehaviour
{

    [SerializeField]
    private GameObject pPrefab;


    [SerializeField]
    private GameObject welcomePanel;
    [SerializeField]
    private PlacementObject[] placedObjects;
    [SerializeField]
    private Button dismissButton;
    [SerializeField]
    BookController bookCTRL;
       
    private Camera cam;

    private Vector2 touchPosition = default;

    
    public GameObject placedPrefab
    {
        get
        {
            return pPrefab;
        }
        set
        {
            pPrefab = value;
        }
    }


    void Awake()
    {
        cam = GetComponent<Camera>();
        dismissButton.onClick.AddListener(Dismiss);
        ChangeSelectedObject(placedObjects[0],0);
    }


    private void Dismiss() => welcomePanel.SetActive(false);


    /*
    private void HandleTouch(int touchFingerId, Vector3 touchPosition, TouchPhase touchPhase)
    {
        switch (touchPhase)
        {
            case TouchPhase.Began:
                // TODO
                break;
            case TouchPhase.Moved:
                // TODO
                break;
            case TouchPhase.Ended:
                // TODO
                break;
        }
    }
    */

    void Update()
    {

        /*
        // Handle native touch events
        foreach (Touch touch in Input.touches)
        {
            HandleTouch(touch.fingerId, Camera.main.ScreenToWorldPoint(touch.position), touch.phase);
        }

        // Simulate touch events from mouse events
        if (Input.touchCount == 0)
        {
            if (Input.GetMouseButtonDown(0))
            {
                HandleTouch(10, Camera.main.ScreenToWorldPoint(Input.mousePosition), TouchPhase.Began);
            }
            if (Input.GetMouseButton(0))
            {
                HandleTouch(10, Camera.main.ScreenToWorldPoint(Input.mousePosition), TouchPhase.Moved);
            }
            if (Input.GetMouseButtonUp(0))
            {
                HandleTouch(10, Camera.main.ScreenToWorldPoint(Input.mousePosition), TouchPhase.Ended);
            }
        }

        */









        if (welcomePanel.activeSelf)
            return;

        

        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hitObject;
            if (Physics.Raycast(ray, out hitObject))
            {
                if (hitObject.transform.name == "Book_Collider_L")                
                    bookCTRL.TurnNextPage();
                
                else if (hitObject.transform.name == "Book_Collider_R")
                    bookCTRL.TurnPrevPage();


                int inputCount = Input.touchCount;

                PlacementObject placementobject = hitObject.transform.GetComponent<PlacementObject>();
                if (placementobject != null)
                    ChangeSelectedObject(placementobject, inputCount);
            }
                       
        }
        

        /*
        int inputCount = Input.touchCount;

        if (inputCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            touchPosition = touch.position;
            if (touch.phase == TouchPhase.Began)
            {
                Ray ray = cam.ScreenPointToRay(touch.position);
                RaycastHit hitObject;
                if (Physics.Raycast(ray, out hitObject))
                {
                    Debug.Log("hit" + hitObject.transform.name);

                    if (hitObject.transform.name == "Book_Collider_L")
                        bookCTRL.TurnNextPage();

                    else if (hitObject.transform.name == "Book_Collider_R")
                        bookCTRL.TurnPrevPage();

                    PlacementObject placementobject = hitObject.transform.GetComponent<PlacementObject>();
                    if (placementobject != null)
                        ChangeSelectedObject(placementobject, inputCount);
                }

            }
        }*/
    }







    private void ChangeSelectedObject(PlacementObject selected, int inputCount)
    {
        foreach (PlacementObject current in placedObjects)
        {
            if (selected != current)
                current.isSelected = false;
            else
                current.isSelected = true;
        }
    }
}