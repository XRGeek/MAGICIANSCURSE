using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DelayedBehaviour : MonoBehaviour
{

    public UnityEvent OnTargetLost;

    Coroutine myco;

    public GameObject gameObj1;

    public void DoAction()
    {
        myco = StartCoroutine(RoutineWork());
    }

    public void CancelAction()
    {
        if (myco != null)
            StopCoroutine(myco);
    }

    IEnumerator RoutineWork()
    {
        yield return new WaitForSeconds(0.8f);

        OnTargetLost?.Invoke();

    }
}
