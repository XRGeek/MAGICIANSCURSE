using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemBehaviour : MonoBehaviour
{
    private Animator portalAnim;
    Transform keyPos_1;
    Transform keyPos_2;
    [SerializeField]
    Transform particleTarget;

    [SerializeField]
    Crown_Key_Puzzle_Part ckpPart;


    [SerializeField]
    GameObject IT;
    [SerializeField]
    string gemPosName_01;
    [SerializeField]
    string gemPosName_02;
    [SerializeField]
    Transform gemSlotTarget;

    //Transform gemTrans;
    Transform target;
    Vector3 keyRot;
    Vector3 keyPos;

    bool closeEnough = false;
    float lerpDuration = 1f;
    [SerializeField]
    float timeElapsed = 0.0f;
    private float speed = 5.0f;
    private float gemSlotAngle;

    int step;
    bool portalVisible = false;

    [SerializeField]
    private AudioClip sfxClip;
    private AudioSource sfx;

    [SerializeField]
    private GameObject spawnParticles;

    public bool solved = false;
    public string PuzzleName;



    bool nomorescanning = false;
    private void OnEnable()
    {
        var chM = FindObjectOfType<ChapterManager>();
        if (chM != null)
            solved=chM.IsPuzzleSolved(PuzzleName);

        if (solved)
        {
            nomorescanning = true;
            //step = 3;
            FindObjectOfType<MeshRenderer>().enabled = true;
            FindObjectOfType<SphereCollider>().enabled = true;
            keyPos_2 = GameObject.Find(gemPosName_02).transform;
            transform.parent = gemSlotTarget;
            transform.localPosition = keyPos_2.localPosition;
            transform.rotation = keyPos_2.rotation;
            transform.localScale = keyPos_2.localScale;
        }

    }

   

    public void TPGem()
    {
        step = 3;
        keyPos_2 = GameObject.Find(gemPosName_02).transform;
        transform.parent = gemSlotTarget;
        transform.localPosition = keyPos_2.localPosition;
        transform.rotation = keyPos_2.rotation;
        transform.localScale = keyPos_2.localScale;

        FindObjectOfType<MeshRenderer>().enabled = true;
        FindObjectOfType<SphereCollider>().enabled = true;

        gameObject.SetActive(true);
       
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject == gemSlotTarget.gameObject && portalVisible)
        {
            closeEnough = true;
            Destroy(other.GetComponent<Collider>());
            Destroy(other.GetComponent<Rigidbody>());
        }
    }

    public void PortalNotActive()
    {
        portalVisible = false;
        //Invoke("Delay_DisableMarker_01", 0.7f);
    }

    public void PortalActive()
    {
        portalVisible = true;
    }
    private void Delay_DisableMarker_01()
    {
        portalVisible = false;
    }

    void Start()
    {
        sfx = GetComponent<AudioSource>();
        keyRot = this.transform.eulerAngles;
        keyPos = this.transform.position;


        var chM = FindObjectOfType<ChapterManager>();
        if (chM != null)
            solved = chM.IsPuzzleSolved(PuzzleName);


        if (solved)
        {
            nomorescanning = true;
        }
            
     
    }

    void Update()
    {

        Debug.Log("portalVisible:"+ portalVisible+ " step:"+ step+ " nomorescanning:"+ nomorescanning);
        if (!portalVisible)        
            return;
        
        if (step > 3)        
            return;

        if (nomorescanning)
            return;


        closeEnough = true;

        if (portalVisible && closeEnough)
        {
            if (step == 0)
            {
                sfx.Play();
                keyPos_1 = GameObject.Find(gemPosName_01).transform;
                keyPos_2 = GameObject.Find(gemPosName_02).transform;

                Vector3 gPos = this.transform.position;
                this.transform.SetParent(gemSlotTarget.transform);
                this.transform.position = gPos;
                target = keyPos_1;
                Destroy(GetComponent<SelfRotation>());
                IT.SetActive(false);
                step++;
            }

            else if (step > 0)
            {
                if (timeElapsed < lerpDuration)
                {
                    this.transform.position = Vector3.Lerp(this.transform.position, target.position, speed * Time.deltaTime / lerpDuration);
                    this.transform.rotation = Quaternion.Lerp(this.transform.rotation, target.rotation, speed * Time.deltaTime / lerpDuration);
                    this.transform.localScale = Vector3.Lerp(this.transform.localScale, target.localScale, speed * Time.deltaTime / lerpDuration);

                    timeElapsed += Time.deltaTime;
                }

                else if (timeElapsed >= lerpDuration)
                {
                    timeElapsed = 0.0f;

                    Round(this.transform.eulerAngles);
                    Round(this.transform.position);

                    switch (step)
                    {
                        case 1:
                            target = keyPos_1;
                            gemSlotAngle = this.transform.eulerAngles.y + 360;
                            break;
                        case 2:
                            target = keyPos_2;
                            ckpPart.AddGem(this.gameObject.name);
                            sfx.clip = sfxClip;
                            sfx.Play();
                            GameObject particles = Instantiate(spawnParticles, particleTarget.position, particleTarget.rotation) as GameObject;
                            particles.transform.parent = particleTarget;
                            SolvePuzzle();
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
}
