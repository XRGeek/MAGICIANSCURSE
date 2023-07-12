using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CoinFallAlert : MonoBehaviour
{
    public Button cButton;
    [SerializeField]
    private Transform respawnTarget;
    float timeElapsed;
    float lerpDuration = 2f;
    public bool inScale;
    public bool isLeft;

    [SerializeField]
    private Color redBlink_01;
    [SerializeField]
    private Color redBlink_02;

    private Rigidbody rb;

    private int collisionCount = 0;

    private void OnEnable()
    {
        rb.velocity = Vector3.zero;
    }
    private void OnDisable()
    {
        cButton.image.color = Color.white;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.name == "Plane")
        {
            cButton.image.color = Color.red;
            inScale = false;
            timeElapsed = 0.0f;
        }

        if (collision.transform.name == "Scale.L")
            isLeft = true;
        if (collision.transform.name == "Scale.R")
            isLeft = false;

        if (collision.rigidbody!=null && collision.rigidbody.transform.tag == "ScalePart")
        {
            timeElapsed = 0.0f;
            cButton.image.color = Color.cyan;
            inScale = true;
        }

        collisionCount++;
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.transform.name == "Scale.L" || collision.transform.name == "Scale.R")
        {
            inScale = false;
            isLeft = false;
        }
        collisionCount--;
    }

    void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }


    void Update()
    {
        if (collisionCount > 0 || inScale)
            return;


        if (timeElapsed < lerpDuration)
        {            
            timeElapsed += Time.deltaTime;
        }

        else if (timeElapsed >= lerpDuration)
        {
            timeElapsed = 0.0f;
            cButton.image.color = Color.Lerp(redBlink_01, redBlink_02, Mathf.PingPong(Time.time, 1));
            transform.position = respawnTarget.position;
        }
    }
}
