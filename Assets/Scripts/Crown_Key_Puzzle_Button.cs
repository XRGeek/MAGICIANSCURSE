using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Crown_Key_Puzzle_Button : MonoBehaviour
{
    [SerializeField]
    int pID;

    private RectTransform rTrans;
    private float speed = 5.0f;
    private float rAngle = 60.0f;

    [SerializeField]
    private float startAngle = 0.0f;
    [SerializeField]
    Crown_Key_Puzzle_Part pPuzzle;

    private float newAngle;
    [SerializeField]
    private AudioClip[] turnSound;
    private AudioSource audio;
    float lerpDuration = 3.0f;
    float timeElapsed = 0.0f;

    void Start()
    {
        audio = GetComponent<AudioSource>();
        gameObject.GetComponent<Button>().onClick.AddListener(ButtonClicked);
        rTrans = GetComponent<RectTransform>();
        rTrans.localEulerAngles = new Vector3(0, 0, startAngle);
        newAngle = startAngle;
    }

    private void ButtonClicked()
    {



#if UNITY_EDITOR
        if (Input.GetKey(KeyCode.T))
        {
            timeElapsed = 0.0f;
            newAngle = 0;
            return;
        }

#endif


        audio.clip = turnSound[Random.Range(0, turnSound.Length - 1)];
        audio.Play();
        pPuzzle.UpdateAngles(pID - 1, false);
        timeElapsed = 0.0f;
        newAngle = newAngle + rAngle;
        Mathf.Round(newAngle * 100 / 100);
        if (newAngle >= 359.9f || newAngle <= -359.9f)
            newAngle = 0;
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

            if (newAngle == 0.0f)
            {
                rTrans.localEulerAngles = new Vector3(0, 0, 0);
                if(pPuzzle.isActiveAndEnabled)
                    pPuzzle.UpdateAngles(pID - 1, true);
            }
            else
            {
                if (pPuzzle.isActiveAndEnabled)
                    pPuzzle.UpdateAngles(pID - 1, false);
            }
        }
    }

    public void PutThemRight()
    {
        timeElapsed = 0.0f;
        newAngle = 0;
    }


}
