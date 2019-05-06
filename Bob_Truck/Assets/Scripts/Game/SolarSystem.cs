using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SolarSystem : MonoBehaviour {

    public GameObject Sun;

    public GameObject point;

    public GameObject details;

    public float radius = 9.5f;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    public void ShowPointOrDetails(float scalePercent)
    {
        float tempPercent = scalePercent;
        if (scalePercent > 0)
        {
            point.SetActive(false);
            details.SetActive(true);

            if (tempPercent > 20)
                tempPercent = 20;

            details.transform.localScale = new Vector3(tempPercent / 20, tempPercent / 20, tempPercent / 20);
        }
        else
        {
            point.SetActive(true);
            details.SetActive(false);

            if (tempPercent < -20)
                tempPercent = -20;

            var scale = -(tempPercent) / 20 * 3;
            //if (scale < 1)
            //    scale = 1;

            point.transform.Find("point").localScale = new Vector3(scale, scale, scale);
        }
        
    }
}
