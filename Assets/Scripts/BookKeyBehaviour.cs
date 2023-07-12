using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BookKeyBehaviour : MonoBehaviour
{
    [SerializeField]
    private BookController bookCtrl;
    GameObject bookObject;
    Transform keyPos_1;
    Transform keyPos_2;
    Transform keyPos_3;
    Transform keyPos_4;
    Transform keyPos_5;
    Transform keyPos_6;
    Transform keyTrans;
    Transform target;



    float lerpDuration = 3.0f;
    [SerializeField]
    float timeElapsed = 0.0f;
    private float speed = 5.0f;

    int step=0;
    bool bookVisible = false;

    [SerializeField]
    AudioClip[] sfxClips;
    AudioSource sfx;
    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if (solved)
        {
            Transform[] transChilds = bookCtrl.GetComponentsInChildren<Transform>(true);
            Debug.Log(transChilds.Length);
            foreach (Transform trans in transChilds)
                if (trans.name == "KeyPos_6")
                    keyPos_6 = trans;

            
            transform.parent = bookCtrl.transform; 
            transform.position = keyPos_6.position;
            transform.rotation = keyPos_6.rotation;
            step = 6;
        }
    }

    public void bookNotActive()
    { bookVisible = false; }
    public void bookActive()
    {
        bookVisible = true; 
        bookObject = bookCtrl.gameObject;
    }
    void init()
    {
        bookObject = bookCtrl.gameObject;
    }

    void Start()
    {
        sfx = GetComponent<AudioSource>();
        keyTrans = GetComponent<Transform>();
    }

    void Update()
    {
        if (!bookVisible || solved)        
            return;
        
        if (step > 6)
        {
            SolvePuzzle();
            return;
        }

        if (bookObject == null)        
            return;
        
        if (bookObject.activeInHierarchy)
        {
            if (step == 0)
            {
                keyPos_1 = GameObject.Find("KeyPos_1").transform;
                keyPos_2 = GameObject.Find("KeyPos_2").transform;
                keyPos_3 = GameObject.Find("KeyPos_3").transform;
                keyPos_4 = GameObject.Find("KeyPos_4").transform;
                keyPos_5 = GameObject.Find("KeyPos_5").transform;
                keyPos_6 = GameObject.Find("KeyPos_6").transform;

                Vector3 kPos = keyTrans.position;
                keyTrans.parent = bookCtrl.transform;
                keyTrans.position = kPos;

                target = keyPos_1;
                StartCoroutine(PlayAudioDelayed(0.2f, 0));
                Destroy(GetComponent<SelfRotation>());
                step++;
            }
            
            else if (step > 0)
            {
                if (timeElapsed < lerpDuration)
                {
                    if (step == 3)
                    {
                        float t = timeElapsed / lerpDuration;
                        t = t * t * (3f - 2f * t);
                        keyTrans.Rotate(Vector3.forward * speed * 96 * Time.deltaTime);
                        timeElapsed += Time.deltaTime*4;
                    }
                    else if(step == 2)
                    {
                        keyTrans.position = Vector3.Lerp(keyTrans.position, target.position, 2 * speed * Time.deltaTime / lerpDuration);
                        keyTrans.rotation = Quaternion.Lerp(keyTrans.rotation, target.rotation, 2 * speed * Time.deltaTime / lerpDuration);
                        timeElapsed += 2 * Time.deltaTime;
                    }
                    else
                    {
                        keyTrans.position = Vector3.Lerp(keyTrans.position, target.position, speed * Time.deltaTime / lerpDuration);

                        keyTrans.rotation = Quaternion.Lerp(keyTrans.rotation, target.rotation, speed * Time.deltaTime / lerpDuration);
                        timeElapsed += Time.deltaTime;
                    }

                }

                else if (timeElapsed >= lerpDuration)
                {
                    timeElapsed = 0.0f;
                    Round(keyTrans.eulerAngles);
                    Round(keyTrans.position);

                    switch (step)
                    {
                        case 1:
                            target = keyPos_2;
                            break;
                        case 2:
                            target = keyPos_3;
                            StartCoroutine(PlayAudioDelayed(0f, 1));
                            break;
                        case 3:
                            Quaternion nRotation = Quaternion.Euler(keyTrans.eulerAngles.x, keyTrans.eulerAngles.y-360, keyTrans.eulerAngles.z);
                            keyTrans.rotation = nRotation;
                            bookCtrl.GetBookKey();
                            
                            target = keyPos_4;
                            break;
                        case 4:
                            target = keyPos_5;
                            break;
                        case 5:
                            target = keyPos_6;
                            break;
                    }
                    step++;
                }
            }            
        }
    }
    public void SolvePuzzle()
    {
        solved = true;
        FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }
    public static Vector3 Round(Vector3 vector3, int decimalPlaces = 2)
    {
        float multiplier = 1;
        for (int i = 0; i < decimalPlaces; i++)
        {
            multiplier *= 10f;
        }
        return new Vector3(
            Mathf.Round(vector3.x * multiplier) / multiplier,
            Mathf.Round(vector3.y * multiplier) / multiplier,
            Mathf.Round(vector3.z * multiplier) / multiplier);
    }

    private IEnumerator PlayAudioDelayed(float delay, int clipID)
    {
        yield return new WaitForSeconds(delay);
        sfx.clip = sfxClips[clipID];
        sfx.Play();
    }
}
