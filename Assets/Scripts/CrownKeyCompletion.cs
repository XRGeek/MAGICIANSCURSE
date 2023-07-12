using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Vuforia;

public class CrownKeyCompletion : MonoBehaviour
{

    //[SerializeField]
    //private GameObject completeKey;
    [SerializeField]
    private bool marker_01;
    [SerializeField]
    private bool marker_02;
    [SerializeField]
    private bool marker_03;

    [SerializeField]
    private SpriteRenderer marker_01_mesh;
    [SerializeField]
    private SpriteRenderer marker_02_mesh;

    float lerpDuration = 4f;
    float timeElapsed = 0.0f;
    private float speed = 5f;
    private bool animating_Marker_1 = false;
    private bool animating_Marker_2 = false;

    [SerializeField]
    private GameObject IT_01;
    [SerializeField]
    private GameObject IT_02;
    [SerializeField]
    private GameObject IT_03;

    [SerializeField]
    private bool solvedPart_1 = false;
    [SerializeField]
    private bool solvedPart_2 = false;

    [SerializeField]
    private bool alignedPart_1 = false;
    private bool AlignedPart_1_A = false;
    private bool AlignedPart_1_B = false;

    [SerializeField]
    private bool alignedPart_2 = false;
    private bool AlignedPart_2_A = false;
    private bool AlignedPart_2_B = false;

    public bool solved = false;

    public string PuzzleName;
    [SerializeField]
    Animator animEye;
    [SerializeField]
    Animator animKey;

    private void OnEnable()
    {
        if (solved)
        {
            animEye.SetBool("Solved", true);
            animKey.SetBool("Solved", true);
           IT_01.GetComponent<ImageTargetBehaviour>().enabled = false;
           IT_02.GetComponent<ImageTargetBehaviour>().enabled = false;

            IT_01.SetActive(false);
            IT_02.SetActive(false);
        }
    }

    void Start()
    {
        marker_01 = false;
        marker_02 = false;
        marker_03 = false;
    }

    private void OnTriggerEnter(Collider other)
    {
        if(!alignedPart_1)
        {
            if (other.name == "Part_01_Col_A")
                AlignedPart_1_A = true; 
            if (other.name == "Part_01_Col_B")
                AlignedPart_1_B = true;

            if (AlignedPart_1_A || AlignedPart_1_B)
            {
                animating_Marker_1 = true;
                alignedPart_1 = true;
            }               
        }

        if (!alignedPart_2)
        {
            if (other.name == "Part_02_Col_A")
                AlignedPart_2_A = true;
            if (other.name == "Part_02_Col_B")
                AlignedPart_2_B = true;

            if (AlignedPart_2_A || AlignedPart_2_B)
            {
                animating_Marker_2 = true;
                alignedPart_2 = true;
            } 
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (alignedPart_1)
        {
            //if (other.name == "Part_01_Col_A")
            //    AlignedPart_1_A = false;
            //if (other.name == "Part_01_Col_B")
            //    AlignedPart_1_B = false;

            //marker_01_mesh.transform.SetParent(IT_01.transform);
            //marker_01_mesh.material.color = new Color(1, 1, 1, 0);
        }

        if (alignedPart_2)
        {
            //if (other.name == "Part_02_Col_A")
            //    AlignedPart_2_A = false;
            //if (other.name == "Part_02_Col_B")
            //    AlignedPart_2_B = false;

            //marker_02_mesh.material.color = new Color(1, 1, 1, 0);
            //marker_02_mesh.transform.SetParent(IT_02.transform);

        }
    }

    void Update()
    {
        if (solved) return;


        

        if (marker_01 && marker_03)
        {
            solvedPart_1 = true;
            animating_Marker_1 = true;
            alignedPart_1 = true;
        }
            
        if (marker_02 && marker_03)
            solvedPart_2 = true;
        if (alignedPart_1 && solvedPart_1)
        {
            marker_01_mesh.transform.SetParent(IT_03.transform);
            marker_01_mesh.GetComponent<AudioSource>().Play();
            IT_01.SetActive(false);
        }

        if (alignedPart_2 && solvedPart_2)
        {
            marker_02_mesh.transform.SetParent(IT_03.transform);
            marker_02_mesh.GetComponent<AudioSource>().Play();
            IT_02.SetActive(false);
        }


        if (solvedPart_1 && solvedPart_2)
        {
            if (alignedPart_1 && alignedPart_2)
            {
                IT_01.SetActive(false);
                IT_02.SetActive(false);
                animEye.SetBool("Solved", true);
                animKey.SetBool("Solved", true);
                SolvePuzzle();
            }
        }


        if (animating_Marker_1)
        {
            if (timeElapsed < lerpDuration)
            {  
                timeElapsed += Time.deltaTime;

                float alphaValue = Mathf.Lerp(0, 1, timeElapsed / lerpDuration);
                //marker_01_mesh.material.color = new Color(1, 1, 1, alphaValue);
                marker_01_mesh.material.SetColor("_BaseColor", new Color(1, 1, 1, alphaValue));
            }

            else if (timeElapsed >= lerpDuration)
            {
                timeElapsed = 0.0f;
                marker_01_mesh.material.SetColor("_BaseColor", new Color(1, 1, 1, 1));

                //marker_01_mesh.material.color = new Color(1, 1, 1, 1);
                animating_Marker_1 = false;
            }
        }
        if (animating_Marker_2)
        {
            Debug.Log("passing animating_Marker_2");
            if (timeElapsed < lerpDuration)
            {
                timeElapsed += Time.deltaTime;

                float alphaValue = Mathf.Lerp(0, 1, timeElapsed / lerpDuration);
                marker_02_mesh.material.SetColor("_BaseColor", new Color(1, 1, 1, alphaValue));

                //marker_02_mesh.material.color = new Color(1, 1, 1, alphaValue);
                Debug.Log("timeElapsed < lerpDuration");
            }

            else if (timeElapsed >= lerpDuration)
            {
                timeElapsed = 0.0f;
                marker_02_mesh.material.SetColor("_BaseColor", new Color(1, 1, 1, 1));
                
                //marker_02_mesh.material.color = new Color(1, 1, 1, 1);
                animating_Marker_2 = false;

                Debug.Log("timeElapsed >= lerpDuration");
            }
        }
    }


    Coroutine co,co2,co3;

    public void EnableMarker_01()
    {

        if (co != null)
            StopCoroutine(co);


        marker_01 = true;

        /// just for testing...
        //animating_Marker_1 = true;
        //alignedPart_1 = true;

    }
    public void DisableMarker_01()
    {
        if (co != null)
            StopCoroutine(co);

        co=StartCoroutine(Delay_DisableMarker_01());
    }

    public void EnableMarker_02()
    {
        if (co2 != null)
            StopCoroutine(co2);

        marker_02 = true;

        /// just for testing...
        //animating_Marker_2 = true;
        //alignedPart_2 = true;
    }
    public void DisableMarker_02()
    {

        if (co2 != null)
            StopCoroutine(co2);

        co2 = StartCoroutine(Delay_DisableMarker_02());

    }
    public void EnableMarker_03()
    {

        if (co3 != null)
            StopCoroutine(co3);

        marker_03 = true;

    }
    public void DisableMarker_03()
    {
        //Invoke("Delay_DisableMarker_03", 0.7f);

        if (co3 != null)
            StopCoroutine(co3);

        co3 = StartCoroutine(Delay_DisableMarker_03());
    }
    public void SolvePuzzle()
    {
        solved = true;


        var cm = FindObjectOfType<ChapterManager>();
        if(cm!=null)
            cm.UpdatePuzzle(PuzzleName, true);
        //FindObjectOfType<ChapterManager>().UpdatePuzzle(PuzzleName, true);
    }

    IEnumerator Delay_DisableMarker_01()
    {
        yield return new WaitForSeconds(0.7f);
        marker_01 = false;
    }

    IEnumerator Delay_DisableMarker_02()
    {
        yield return new WaitForSeconds(0.7f);
        marker_02 = false;
    }

    //private void Delay_DisableMarker_02()
    //{
    //    marker_02 = false;
    //}
    IEnumerator Delay_DisableMarker_03()
    {
        yield return new WaitForSeconds(0.7f);
        marker_03 = false;
    }
}
