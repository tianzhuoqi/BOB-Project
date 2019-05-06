using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TouchControl : MonoBehaviour {

	public Camera m_cameraControl;

	public float m_cameraX;
	public float m_cameraY;

	public float m_cameraRoll = 60;//相机X旋转

	public float m_cameraControlDeep = 400;//可控缩放距离
	public float m_cameraBaseDeep = 10;//初始相机距离
	public float m_scalePercent =100;//缩放程度，初始为100

	public float m_moveStep = 4;//拖动移动步长
	public float m_scaleStep = 5;//缩放比例步长

	public float m_moveStepEditor = 10;//Editor拖动移动步长
	public float m_scaleStepEditor = 15;//Editor缩放比例步长

	Vector3 lastMouse;
	bool mousePress;
	float moveDeltaK = 0.004f;
	float scrollDeltaK = 0.05f;
	float firstTwoTouchD = 0;
	float lastTouchD = 0;
	bool twoTouchPress = false;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		CheckTouch();

		if (m_scalePercent < -100) m_scalePercent = -100;
		if (m_scalePercent > 100) m_scalePercent = 100;
		m_cameraControl.transform.localRotation = Quaternion.Euler(m_cameraRoll,0,0);
		Vector3 cameraFoward = m_cameraControl.transform.forward;
		Vector3 cameraOffset = new Vector3(m_cameraX, 0, m_cameraY) - cameraFoward * (m_cameraBaseDeep + m_cameraControlDeep * (100 - m_scalePercent) / 100);
		m_cameraControl.transform.localPosition = cameraOffset;
	}

	void CheckTouch()
	{
		float scaleK = (1+(100 - m_scalePercent) / 100 * m_cameraControlDeep / m_cameraBaseDeep);
		
		if (Input.touchCount > 1)
		{
			Vector3 t1 = Input.GetTouch(0).position;
			Vector3 t2 = Input.GetTouch(1).position;

			float d = (t1 - t2).sqrMagnitude;
			if (!twoTouchPress)
			{
				firstTwoTouchD = d;
				lastTouchD = d;
				twoTouchPress = true;
			}
			if (twoTouchPress)
			{
				float scaleT = (d - lastTouchD)  / firstTwoTouchD;
				m_scalePercent += scaleT * m_scaleStep * scaleK;
			}
			lastTouchD = d;
		}
		else if (Input.touchCount > 0 && twoTouchPress)
		{
			lastMouse = Input.GetTouch(0).position;
			firstTwoTouchD = 0;
			twoTouchPress = false;
		}


		if (Input.GetMouseButtonDown(0))
		{
			lastMouse = Input.mousePosition;
			mousePress = true;
		}
		if (Input.GetMouseButtonUp(0))
		{
			mousePress = false;
			firstTwoTouchD = 0;
			twoTouchPress = false;
		}
		if (mousePress && Input.touchCount < 2 && firstTwoTouchD==0)
		{
			Vector3 mouseDelta = Input.mousePosition - lastMouse;
#if UNITY_EDITOR
			float step = m_moveStepEditor;
#else
			float step = m_moveStep;
#endif
			m_cameraX -= mouseDelta.x * moveDeltaK * step * scaleK;
			m_cameraY -= mouseDelta.y * moveDeltaK * step * scaleK;
			lastMouse = Input.mousePosition;
			firstTwoTouchD = 0;
			twoTouchPress = false;
		}
#if UNITY_EDITOR
		m_scalePercent += Input.mouseScrollDelta.y * scrollDeltaK * m_scaleStepEditor;
#else
		m_scalePercent += Input.mouseScrollDelta.y * scrollDeltaK * m_scaleStep;
#endif
	}
}
