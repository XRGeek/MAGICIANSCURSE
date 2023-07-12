using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;

public class Vibro_Pyramid_Puzzle : MonoBehaviour
{
    private bool[] ppAngles;

    [SerializeField]
    private VideoPlayer vPlayer;
    private Transform camTrans;
    private float dist;
    [SerializeField]
    private Image[] puzzlePartImages;
    [SerializeField]
    private Transform camPosTarget;
    [SerializeField]
    private RectTransform[] ppRectTrans;

    float lerpDuration = 12f;
    [SerializeField]
    float timeElapsed = 0.0f;
    private float speed = 16f;
    [SerializeField]
    private GameObject endParticles;
    private bool animating = false;
    private RectTransform thisRectRansform;
    [SerializeField]
    private GameObject tarotCard;

    public bool solved = false;
    public string PuzzleName;

    private void OnEnable()
    {
        if (solved)
        {
            vPlayer.GetComponent<RawImage>().enabled = true;
            vPlayer.Play();
            timeElapsed = 0.0f;
            endParticles.SetActive(true);
            SolvePuzzle();

            for (int i = 0; i < ppRectTrans.Length; i++)
            {
                ppRectTrans[i].GetComponent<Button>().interactable = false;
                puzzlePartImages[i].gameObject.SetActive(false);
            }
        }
    }
    private void Start()
    {
        thisRectRansform = this.GetComponent<RectTransform>();
        camTrans = Camera.main.transform;

        ppAngles = new bool[7];
        for (int i = 0; i < ppAngles.Length; i++)
        {
            ppAngles[i] = false;
        }
    }
    public void UpdateAngles(int pID, bool state)
    {
        ppAngles[pID] = state;
    }

    void Update()
    {
        if (solved)
        {
            if (!vPlayer.isPlaying)
            {
                GetComponent<SwitchUIHelper>().canSwitchHelper = false;
                GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
                tarotCard.SetActive(transform);
                vPlayer.gameObject.SetActive(false);
                this.gameObject.SetActive(false);
            }
        }

        if (animating)
        {
            if (timeElapsed < lerpDuration)
            {
                for (int i = 0; i < ppRectTrans.Length; i++)
                {
                    Vector3 targetPos = new Vector3(ppRectTrans[i].localPosition.x, ppRectTrans[i].localPosition.y, thisRectRansform.localPosition.z);
                    Vector3 newPos = Vector3.Lerp(ppRectTrans[i].localPosition, targetPos, speed * Time.deltaTime / lerpDuration);
                    ppRectTrans[i].localPosition = newPos;
                    timeElapsed += Time.deltaTime;
                }
                vPlayer.gameObject.SetActive(true);
                vPlayer.Prepare();
            }

            else if (timeElapsed >= lerpDuration)
            {
                vPlayer.GetComponent<RawImage>().enabled = true;
                vPlayer.Play();
                timeElapsed = 0.0f;
                endParticles.SetActive(true);
                SolvePuzzle();

                for (int i = 0; i < ppRectTrans.Length; i++)
                {
                    Vector3 newPos = new Vector3(ppRectTrans[i].localPosition.x, ppRectTrans[i].localPosition.y, thisRectRansform.localPosition.z);
                    ppRectTrans[i].localPosition = newPos;
                    ppRectTrans[i].GetComponent<Button>().interactable = false;
                    puzzlePartImages[i].gameObject.SetActive(false);
                }
            }
        }

        if (camTrans)
        {
            dist = Vector3.Distance(camTrans.position, camPosTarget.position);
            if (dist > 0.4)
            {
                for (int i = 0; i < puzzlePartImages.Length; i++)
                {
                    Color newColor = new Color(1, 1, 1, 1 / (dist * 3));
                    puzzlePartImages[i].color = newColor;
                }
            }
            else
            {
                for (int i = 0; i < puzzlePartImages.Length; i++)
                {
                    puzzlePartImages[i].color = Color.white;
                }
            }
        }

        if (!animating)
        {
            if (isPuzzleComplete())
            {
                animating = true;

                for (int i = 0; i < ppRectTrans.Length; i++)
                {
                    ppRectTrans[i].GetComponent<Button>().interactable = false;
                    ppRectTrans[i].GetComponent<Vibro_Pyramid_Button>().enabled = false;
                }
            }
        }
    }

    private bool isPuzzleComplete()
    {
        for (int i = 0; i < ppAngles.Length; i++)
        {
            if (ppAngles[i] == false)            
                return false;            
        }
        GetComponent<AudioSource>().Play();
        return true;
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
}
