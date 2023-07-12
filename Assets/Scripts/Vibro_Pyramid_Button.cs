using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Vibro_Pyramid_Button : MonoBehaviour
{
    [SerializeField]
    int pID;

    private RectTransform rTrans;
    private float speed = 5.0f;
    private float rAngle = 60.0f;

    [SerializeField]
    private float startAngle = 0.0f;
    [SerializeField]
    Vibro_Pyramid_Puzzle pPuzzle;

    private float newAngle;
    float lerpDuration = 3.0f;
    float timeElapsed = 0.0f;
    [SerializeField]
    bool isSymetrical;

    void Start()
    {
        gameObject.GetComponent<Button>().onClick.AddListener(ButtonClicked);
        rTrans = GetComponent<RectTransform>();
        rTrans.localEulerAngles = new Vector3(0, 0, startAngle);
        newAngle = startAngle;
    }

    private void ButtonClicked()
    {
        newAngle = newAngle + rAngle;
        if (newAngle == 360)
            newAngle = 0;
        timeElapsed = 0.0f;
    }
        
    void Update()
    {       
        if (timeElapsed < lerpDuration)
        {
            float angle = Mathf.LerpAngle(rTrans.localEulerAngles.z, newAngle, speed * Time.deltaTime);
            rTrans.localEulerAngles = new Vector3(0, 0, angle);
            timeElapsed += Time.deltaTime;
        }
        else if (timeElapsed >= lerpDuration)
        {
            Mathf.Round(rTrans.localEulerAngles.z * 100 / 100);
            if (rTrans.localEulerAngles.z >= 359.9f || rTrans.localEulerAngles.z <= -359.9f)
                rTrans.localEulerAngles = new Vector3(0, 0, 0);

            Mathf.Round(newAngle * 100 / 100);
            if(isSymetrical)
            {
                if (newAngle == 120 || newAngle == 240)
                {
                    newAngle = 0;
                }
            }
            if (newAngle == 360)
                newAngle = 0;

            if (newAngle == 0.0f)
            {
                rTrans.localEulerAngles = new Vector3(0, 0, 0);
                pPuzzle.UpdateAngles(pID - 1, true);
            }
            else            
                pPuzzle.UpdateAngles(pID - 1, false);
            
        }
    }    
}
