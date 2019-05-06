using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

using System.Reflection;

using UnityEngine;
using Debug = UnityEngine.Debug;

/// <summary>
/// 日志类封装
/// create by：沈俊杰 （火球）
/// date: 2017.8.14
/// 封装unity的日志类
/// （1）日志堆栈信息的重定向（UNITY_EDITOR才有此功能）
/// 
/// 未完成：
/// 对lua支持
/// </summary>
public class Unity3DLogUtility
{
    public static void LogBreak(object message, UnityEngine.Object sender = null)
    {
        LogInfo(message, sender);
        Debug.Break();
    }

    public static void LogDebug(object message, UnityEngine.Object sender = null)
    {
        LogLevelFormat(0, message, sender);
    }

    public static void LogInfo(object message, UnityEngine.Object sender = null)
    {
        LogLevelFormat(1, message, sender);
    }

    public static void LogWarn(object message, UnityEngine.Object sender = null)
    {
        LogLevelFormat(2, message, sender);
    }

    public static void LogError(object message, UnityEngine.Object sender = null)
    {
        LogLevelFormat(3, message, sender);
    }

    public static void LogFatal(object message, UnityEngine.Object sender = null)
    {
        LogLevelFormat(4, message, sender);
    }

    private static void LogLevelFormat(int level, object message, UnityEngine.Object sender)
    {
        string levelFormat = level.ToString().ToUpper();
        string timeFormat = "Frame:" + Time.frameCount + "," + DateTime.Now.Millisecond + "ms";
        StringBuilder sb = new StringBuilder();
        sb.AppendFormat("[{0}][{1}]{2}", levelFormat, timeFormat, message);

        if (level == 2)
        {
            Debug.LogWarning(sb, sender);
        }
        else if (level == 3 || level == 4)
        {
            Debug.LogError(sb, sender);
        }
        else
        {
            Debug.Log(sb, sender);
        }
    }
}