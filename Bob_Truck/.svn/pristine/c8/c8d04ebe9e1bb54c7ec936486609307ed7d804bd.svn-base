using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class NConst
{
    public const string AppName = "com.hyperjoy.project";                   //应用程序名称

    #region Lua相关
    /// <summary>
    /// 取得数据存放目录
    /// </summary>
    public static string DataPath
    {
        get
        {
            string game = AppName.ToLower();
            if (Application.isMobilePlatform)
            {
                return Application.persistentDataPath + "/" + game + "/";
            }
            if (Application.isEditor)
            {
                return Application.dataPath + "/ResourcesAssets/";
            }
            if (Application.platform == RuntimePlatform.WindowsPlayer)
            {
                return Application.streamingAssetsPath + "/";
            }
            if (Application.platform == RuntimePlatform.OSXEditor)
            {
                int i = Application.dataPath.LastIndexOf('/');
                return Application.dataPath.Substring(0, i + 1) + game + "/";
            }
            NDebug.LogError("NConst DataPath Error!");
            return "";
        }
    }
    #endregion
}
