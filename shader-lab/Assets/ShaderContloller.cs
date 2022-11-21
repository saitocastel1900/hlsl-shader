using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderContloller : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Renderer>().material.SetColor("_BaseColor",new Color(1,1,1,1));
    }

}
