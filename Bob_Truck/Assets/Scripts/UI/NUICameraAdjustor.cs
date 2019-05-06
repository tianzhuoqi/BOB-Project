using UnityEngine;
using System.Collections;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class NUICameraAdjustor : MonoBehaviour 
{
	public const int standard_width = 640;
    public const int standard_height = 1136;

	private float device_width = 0f;
	private float device_height = 0f;

    public Camera uiCamera;
    public UIRoot uiRoot;

    public bool always = false;

	void Awake()
	{
        uiRoot.scalingStyle = UIRoot.Scaling.Constrained;
        uiRoot.fitHeight = true;
        uiRoot.manualHeight = standard_height;

		device_width = Screen.width;
		device_height = Screen.height;

		SetCameraSize();
	}

    void Update()
    {
        if (always)
        {
            device_width = Screen.width;
            device_height = Screen.height;
            SetCameraSize();
        }
    }

	public void SetCameraSize()
	{
		float adjustor = 0f;
		float standard_aspect = (float)standard_width / (float)standard_height;
		float device_aspect = device_width / device_height;
		if (device_aspect < standard_aspect)
		{
			adjustor = standard_aspect / device_aspect;
            uiCamera.orthographicSize = adjustor;
		}
		else
		{
            uiCamera.orthographicSize = 1f;
		}
	}
}
