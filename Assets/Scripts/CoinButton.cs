using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CoinButton : MonoBehaviour
{
    [SerializeField]
    int coinNum;

    [SerializeField]
    ScaleBehaviour ScaleB;
    bool collided;

    [SerializeField]
    private Color redBlink_01;
    [SerializeField]
    private Color redBlink_02;

    void Start()
    {
        gameObject.GetComponent<Button>().onClick.AddListener(ButtonClicked);
    }


    private void ButtonClicked()
    {
        ScaleB.SetCoin(coinNum);
    }
}
