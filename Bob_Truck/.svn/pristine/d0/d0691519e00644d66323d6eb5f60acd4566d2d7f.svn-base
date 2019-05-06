using UnityEngine;
using System.IO;
using System.Collections.Generic;

/// <summary>
/// 日志统一对外接口
/// 绑定在SMain下的DebugObject上
/// 存在程序整个生命周期
/// 通过OPENLOG宏实现开关
/// FATAL > ERROR > WARN > INFO > DEBUG
/// </summary>
public class NDebug : MonoBehaviour 
{
    public Reporter reporter;
    void Awake()
    {
#if OPENLOG
        reporter.gameObject.SetActive(true);
#else
        reporter.gameObject.SetActive(false);
#endif
    }

	void Start () 
    {
        DontDestroyOnLoad(this);
    }

#if OPENLOG	
    static string ParseMessage(string message, params object[] values)
    {
        if (values == null || values.Length == 0)
        {
            return message;
        }
        string newmessage = System.String.Format(message, values);
        return newmessage;
    }
#endif

    public static void LogDebug(string message)
    {
#if OPENLOG
        Unity3DLogUtility.LogDebug(message);
#endif
    }

    public static void LogDebug(string key, params object[] values)
    {
#if OPENLOG
        string message = ParseMessage(key, values);
        Unity3DLogUtility.LogDebug(message);
#endif
    }

    public static void LogInfo(string message)
    {
#if OPENLOG
        Unity3DLogUtility.LogInfo(message);
#endif
    }

    public static void LogInfo(string key, params object[] values)
    {
#if OPENLOG
        string message = ParseMessage(key, values);
        Unity3DLogUtility.LogInfo(message);
#endif
    }

    public static void LogWarn(string message) 
    {
#if OPENLOG
        Unity3DLogUtility.LogWarn(message);
#endif
    }

    public static void LogWarn(string key, params object[] values) 
    {
#if OPENLOG
        string message = ParseMessage(key, values);
        Unity3DLogUtility.LogWarn(message);
#endif
	}

    public static void LogError(string message)
    {
#if OPENLOG
        Unity3DLogUtility.LogError(message);
#endif
    }

    public static void LogError(string key, params object[] values)
    {
#if OPENLOG
        string message = ParseMessage(key, values);
        Unity3DLogUtility.LogError(message);
#endif
    }

    public static void LogFatal(string message)
    {
#if OPENLOG
        Unity3DLogUtility.LogFatal(message);
#endif
    }

    public static void LogFatal(string key, params object[] values)
    {
#if OPENLOG
        string message = ParseMessage(key, values);
        Unity3DLogUtility.LogFatal(message);
#endif
    }

#if RELEASE
    public static bool isdebug = false;
#else
    public static bool isdebug = true;
#endif

#if UNITY_EDITOR
    public static bool iseditor = true;
#else
    public static bool iseditor = false;
#endif
}
