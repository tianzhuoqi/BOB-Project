using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircularMotion : MonoBehaviour {

    public GameObject Sun;

    public float AngularVelocity;

    private float angular;

    private float length;

	// Use this for initialization
	void Start () {
        length = Vector3.Distance(transform.position, Sun.transform.position);
        angular = Vector3.Angle(Vector3.right, transform.position - Sun.transform.position);
	}
	
	// Update is called once per frame
	void Update () {

        angular += (Time.deltaTime * AngularVelocity);

        if(angular > 360)
            angular -= 360;

        transform.localPosition = new Vector3(Mathf.Sin(angular) * length, 0, Mathf.Cos(angular) * length);
	}
}
