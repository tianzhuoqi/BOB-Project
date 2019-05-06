using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class NPlatformLoader
{
    public static void InitBugly()
    {
#if RELEASE

#if UNITY_IPHONE || UNITY_IOS
    	BuglyAgent.InitWithAppId ("f4599fd755");
        BuglyAgent.EnableExceptionHandler();
#elif UNITY_ANDROID
    	BuglyAgent.InitWithAppId ("5c9177f0ec");
        BuglyAgent.EnableExceptionHandler();
#endif

#endif
    }
}
