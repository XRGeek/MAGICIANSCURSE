using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlaneColMusicCards : MonoBehaviour
{

    private MeshCollider col;

    private void Start()
    {
        col = GetComponent<MeshCollider>();
    }
    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            col.enabled = true;
        }
        else if (Input.GetMouseButtonUp(0))
        {
            col.enabled = false;
        }
    }
}
