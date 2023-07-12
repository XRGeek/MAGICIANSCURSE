using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class ScaleBehaviour : MonoBehaviour
{
    [SerializeField]
    GameObject coin_1;
    [SerializeField]
    GameObject coin_2;
    [SerializeField]
    GameObject coin_3;
    [SerializeField]
    GameObject coin_4;
    [SerializeField]
    GameObject coin_5;
    [SerializeField]
    GameObject coin_6;
    [SerializeField]
    GameObject coin_7;
    //    [SerializeField]
    //    GameObject coin_8;

    CoinFallAlert currentCoin_1;
    CoinFallAlert currentCoin_2;
    CoinFallAlert currentCoin_3;
    CoinFallAlert currentCoin_4;
    CoinFallAlert currentCoin_5;
    CoinFallAlert currentCoin_6;
    CoinFallAlert currentCoin_7;
    //    CoinFallAlert currentCoin_8;

    private int selectedCoin = 0;
    private int coinCounter = 0;

    [SerializeField]
    Transform Scale_Support;
    private float scaleAngle;
    private float LastGearAngle = 0f;

    [SerializeField]
    Transform rSide;
    [SerializeField]
    Transform lSide;
    [SerializeField]


    Transform rSidemid;
    [SerializeField]
    Transform lSidemid;
    [SerializeField]


    private GameObject spawnParticles;
    
    Vector3 SidePos;
    private bool coin_1_Active = false;
    private bool coin_2_Active = false;
    private bool coin_3_Active = false;
    private bool coin_4_Active = false;
    private bool coin_5_Active = false;
    private bool coin_6_Active = false;
    private bool coin_7_Active = false;
 //   private bool coin_8_Active = false;

    private float balanceDelay = 1f;
    private float balanceTimer;
    private Animator anim;

    [SerializeField]
    private GameObject message;
    [SerializeField]
    private GameObject scaleUI;

    private AudioSource sfx;
    [SerializeField]
    private AudioSource errorSFX;
    
    private bool waitForBalance = false;
    public bool solved = false;
    public string PuzzleName;

    float lerpDuration = 1f;
    [SerializeField]
    float timeElapsed = 0.0f;
    private float speed = 0.05f;
    [SerializeField]
    private bool forceReset = false;

    private Rigidbody body;

    private bool isLeftSelected=true;

    private void OnEnable()
    {
        Invoke("DelayedLeft", 1f);

        if (!anim)
            anim = GetComponent<Animator>();
        if (!sfx)
            sfx = GetComponent<AudioSource>();

        if (!solved)
        {
            SidePos = lSide.position;
            anim.SetBool("Right", false);
            anim.SetBool("Left", true);
            return;
        }

        scaleUI.SetActive(false);
        GetComponent<SwitchUIHelper>().canSwitchHelper = false;
        GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
        anim.SetBool("Solved", true);

    }

    void Start()
    {
        anim = GetComponent<Animator>();
        sfx = GetComponent<AudioSource>();
        body = Scale_Support.GetComponent<Rigidbody>();




        Invoke("DelayedLeft", 1f);
    }

    void DelayedLeft()
    {
        if (!solved)
        {
            SidePos = lSide.position;
            anim.SetBool("Right", false);
            anim.SetBool("Left", true);
            return;
        }
    }

    public LayerMask mask;
    void Update()
    {
        if (solved)
            return;
                
        if (waitForBalance)
        {
            balanceTimer += Time.deltaTime;

            if (balanceTimer >= balanceDelay)
            {
                message.SetActive(true);
                scaleUI.SetActive(false);
                GetComponent<SwitchUIHelper>().canSwitchHelper = false;
                GameObject.Find("Helpers").GetComponent<UIHelper>().ChangeHelperType(0);
                anim.SetBool("Solved", true);
                SolvePuzzle();
            }
        }

        scaleAngle = Scale_Support.localEulerAngles.y;

        if (Input.GetMouseButtonDown(0))
        {
            PointerEventData pointerData = new PointerEventData(EventSystem.current);
            pointerData.position = Input.mousePosition;

            List<RaycastResult> results = new List<RaycastResult>();
            EventSystem.current.RaycastAll(pointerData, results);

            if (results.Count > 0)
            {
                for (int i = 0; i < results.Count; ++i)
                {
                    if (results[i].gameObject.layer == 5)
                        return;
                }
            }


            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hitObject;
            if (Physics.Raycast(ray, out hitObject, mask))
            {
                if (hitObject.transform == lSide)
                {
                    SidePos = lSidemid.position;
                    anim.SetBool("Right", false);
                    anim.SetBool("Left", true);
                    isLeftSelected = true;
                }

                else if (hitObject.transform == rSide)
                {
                    SidePos = rSidemid.position;
                    anim.SetBool("Right", true);
                    anim.SetBool("Left", false);
                    isLeftSelected = false;
                }
            }
        }


        if (coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
        {
            waitForBalance = false;
        }

            if (coin_2_Active && coin_3_Active && coin_5_Active)
            {
                if (currentCoin_2.inScale && currentCoin_2.isLeft && currentCoin_3.inScale && currentCoin_3.isLeft & currentCoin_5.inScale && !currentCoin_5.isLeft)
                {
                    StartCoroutine("StartReset");
                    waitForBalance = true;
                }
            }


        else if (!coin_1_Active && !coin_2_Active && !coin_3_Active && !coin_4_Active && !coin_5_Active && !coin_6_Active && !coin_7_Active)
        {
            waitForBalance = false;           
            if(!forceReset)
                StartCoroutine("StartReset");
        }
        else
        {
            StopCoroutine("StartReset");
            forceReset = false;
            body.useGravity = true;

        }

        if (forceReset)
        {
            body.useGravity = false;

            if (timeElapsed < lerpDuration)
            {
                if (Scale_Support.localEulerAngles.y > 0f)
                {
                    Scale_Support.eulerAngles = Vector3.Lerp(Scale_Support.eulerAngles, Vector3.zero, speed * Time.deltaTime / lerpDuration);
                    timeElapsed += Time.deltaTime;
                }
                else
                {
                    Scale_Support.eulerAngles = Vector3.Lerp(Scale_Support.eulerAngles, Vector3.zero, speed * Time.deltaTime / lerpDuration);
                    timeElapsed += Time.deltaTime;
                }
            }
            else if (timeElapsed >= lerpDuration)
            {
                timeElapsed = 0.0f;
                Round(Scale_Support.eulerAngles);
                forceReset = false;
                body.useGravity = true;
            }

            return;
        }

        scaleAngle = Mathf.RoundToInt(Scale_Support.localEulerAngles.y);
        if (scaleAngle == LastGearAngle || scaleAngle == LastGearAngle + 360 || scaleAngle == LastGearAngle - 360)
            return;

        if (scaleAngle % 5 == 0)
        {
            LastGearAngle = scaleAngle;
            sfx.Play();
        }
    }

   

    public void SetCoin(int num)
    {


        if (isLeftSelected)
        {
            SidePos = lSidemid.position;
        }
        else
        {
            SidePos = rSidemid.position;
        }

        selectedCoin = num;
        if (selectedCoin != 0)
            SpawnCoin();
    }

    public void SetSide(Vector3 sPos)
    {
        SidePos = sPos;
    }


    private void LateUpdate()
    {

    }


    public void SpawnCoin()
    {

        if (isLeftSelected)
        {
            SidePos = lSidemid.position;
        }
        else
        {
            SidePos = rSidemid.position;
        }

        switch (selectedCoin)
        {
            case 1:
                if (coin_1.activeInHierarchy)
                {
                    balanceTimer = 0f;
                    coin_1_Active = false;
                    currentCoin_1 = coin_1.GetComponent<CoinFallAlert>();
                    coinCounter--;

                    coin_1.SetActive(false);
                    break;
                }
                Instantiate(spawnParticles, SidePos, Quaternion.identity);
                coin_1.transform.position = SidePos;
                coin_1.transform.eulerAngles = new Vector3(0, 0, 0);
                balanceTimer = 0f;
                coin_1_Active = true;
                currentCoin_1 = coin_1.GetComponent<CoinFallAlert>();
                coinCounter++;

                coin_1.SetActive(true);

                if (coinCounter >= 3)
                {
                    if (!(coin_2_Active && coin_3_Active && coin_5_Active) || coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
                        StartCoroutine("PlayError");
                }
                break;

            case 2:
                if (coin_2.activeInHierarchy)
                {
                    balanceTimer = 0f;
                    coin_2_Active = false;
                    currentCoin_2 = coin_2.GetComponent<CoinFallAlert>();
                    coinCounter--;

                    coin_2.SetActive(false);
                    break;
                }
                Instantiate(spawnParticles, SidePos, Quaternion.identity);
                coin_2.transform.position = SidePos;
                coin_2.transform.eulerAngles = new Vector3(0, 0, 0);
                balanceTimer = 0f;
                coin_2_Active = true;
                currentCoin_2 = coin_2.GetComponent<CoinFallAlert>();
                coinCounter++;

                coin_2.SetActive(true);

                if (coinCounter >= 3)
                {
                    if (!(coin_2_Active && coin_3_Active && coin_5_Active) || coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
                        StartCoroutine("PlayError");
                }
                break;

            case 3:
                if (coin_3.activeInHierarchy)
                {
                    balanceTimer = 0f;
                    coin_3_Active = false;
                    currentCoin_3 = coin_3.GetComponent<CoinFallAlert>();
                    coinCounter--;

                    coin_3.SetActive(false);
                    break;
                }
                Instantiate(spawnParticles, SidePos, Quaternion.identity);
                coin_3.transform.position = SidePos;
                coin_3.transform.eulerAngles = new Vector3(0, 0, 0);
                balanceTimer = 0f;
                coin_3_Active = true;
                currentCoin_3 = coin_3.GetComponent<CoinFallAlert>();
                coinCounter++;

                coin_3.SetActive(true);

                if (coinCounter >= 3)
                {
                    if (!(coin_2_Active && coin_3_Active && coin_5_Active) || coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
                        StartCoroutine("PlayError");
                }
                break;

            case 4:
                if (coin_4.activeInHierarchy)
                {
                    balanceTimer = 0f;
                    coin_4_Active = false;
                    currentCoin_4 = coin_4.GetComponent<CoinFallAlert>();
                    coinCounter--;

                    coin_4.SetActive(false);
                    break;
                }
                Instantiate(spawnParticles, SidePos, Quaternion.identity);
                coin_4.transform.position = SidePos;
                coin_4.transform.eulerAngles = new Vector3(0, 0, 0);
                balanceTimer = 0f;
                coin_4_Active = true;
                currentCoin_4 = coin_4.GetComponent<CoinFallAlert>();
                coinCounter++;

                coin_4.SetActive(true); 
                
                if (coinCounter >= 3)
                {
                    if (!(coin_2_Active && coin_3_Active && coin_5_Active) || coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
                        StartCoroutine("PlayError");
                }
                break;

            case 5:
                if (coin_5.activeInHierarchy)
                {
                    balanceTimer = 0f;
                    coin_5_Active = false;
                    currentCoin_5 = coin_5.GetComponent<CoinFallAlert>();
                    coinCounter--;

                    coin_5.SetActive(false);
                    break;
                }
                Instantiate(spawnParticles, SidePos, Quaternion.identity);
                coin_5.transform.position = SidePos;
                coin_5.transform.eulerAngles = new Vector3(0, 0, 0);
                balanceTimer = 0f;
                coin_5_Active = true;
                currentCoin_5 = coin_5.GetComponent<CoinFallAlert>();
                coinCounter++;

                coin_5.SetActive(true);

                if (coinCounter >= 3)
                {
                    if (!(coin_2_Active && coin_3_Active && coin_5_Active) || coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
                        StartCoroutine("PlayError");
                }
                break;

            case 6:
                if (coin_6.activeInHierarchy)
                {
                    balanceTimer = 0f;
                    coin_6_Active = false;
                    currentCoin_6 = coin_6.GetComponent<CoinFallAlert>();
                    coinCounter--;

                    coin_6.SetActive(false);
                    break;
                }
                Instantiate(spawnParticles, SidePos, Quaternion.identity);
                coin_6.transform.position = SidePos;
                coin_6.transform.eulerAngles = new Vector3(0, 0, 0);
                balanceTimer = 0f;
                coin_6_Active = true;
                currentCoin_6 = coin_6.GetComponent<CoinFallAlert>();
                coinCounter++;

                coin_6.SetActive(true);

                if (coinCounter >= 3)
                {
                    if (!(coin_2_Active && coin_3_Active && coin_5_Active) || coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
                        StartCoroutine("PlayError");
                }
                break;

            case 7:
                if (coin_7.activeInHierarchy)
                {

                    balanceTimer = 0f;
                    coin_7_Active = false;
                    currentCoin_7 = coin_7.GetComponent<CoinFallAlert>();
                    coinCounter--;

                    coin_7.SetActive(false);
                    break;
                }
                Instantiate(spawnParticles, SidePos, Quaternion.identity);
                coin_7.transform.position = SidePos;
                coin_7.transform.eulerAngles = new Vector3(0, 0, 0);
                balanceTimer = 0f;
                coin_7_Active = true;
                currentCoin_7 = coin_7.GetComponent<CoinFallAlert>();
                coinCounter++;

                coin_7.SetActive(true);

                if (coinCounter >= 3)
                {
                    if (!(coin_2_Active && coin_3_Active && coin_5_Active) || coin_1_Active || coin_4_Active || coin_6_Active || coin_7_Active)
                        StartCoroutine("PlayError");
                }
                break;
                
        }
        selectedCoin = 0;
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

    private IEnumerator StartReset()
    {
        forceReset = true;
        yield return new WaitForSeconds(4);
        forceReset = false;
    }

    private IEnumerator PlayError()
    {
        yield return new WaitForSeconds(0.5f);
        errorSFX.Play();
        anim.SetTrigger("Error");
    }
}
