using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class Main : MonoBehaviour 
{
    public bool runBundle = false;
    public bool useLocalBundle = false;
	bool isPaused = false;

	void Start () 
	{
        DontDestroyOnLoad(this);
        Application.targetFrameRate = 30;
        NPlatformLoader.InitBugly();

        NManagerResourceModule.SetRunBundle(runBundle);
        NManagerResourceModule.UseLocalBundle = useLocalBundle;
        NManagerResourceModule.Init();
        
        NManagerLua.Instance.InitStart();
	}

	void OnApplicationFocus(bool hasFocus)
	{
		if (isPaused != !hasFocus)
		{
			isPaused = !hasFocus;
			NManagerLua.Instance.CallFunction("OnApplicationStateChange", isPaused);
			//NDebug.LogError("OnApplicationFocus:" + isPaused);
		}
	}

	void OnApplicationPause(bool pauseStatus)
	{
		if (isPaused != pauseStatus)
		{
			isPaused = pauseStatus;
			NManagerLua.Instance.CallFunction("OnApplicationStateChange", isPaused);
			//NDebug.LogError("OnApplicationPause:" + isPaused);
		}
	}
}
