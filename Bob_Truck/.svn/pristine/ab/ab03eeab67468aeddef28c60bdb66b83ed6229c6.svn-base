using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using System.Threading;
using Newtonsoft.Json;

public class CommandBuild
{
    #region 设置配置信息（版本类型、宏、语言）
    public static string UnityCfg = "CompileScript/ruby/Config/build_unity_temp.cfg";
    private static Hashtable LoadCfg()
    {
        var path = System.IO.Path.Combine(Application.dataPath.Replace("Assets", ""), UnityCfg);
        var cfg = File.ReadAllText(path);
        Hashtable cfgData = null;
        cfgData = JsonConvert.DeserializeObject<Hashtable>(cfg);
        if (cfgData == null)
        {
            Debug.LogError("Read UnityCfg Error!");
        }
        return cfgData;
    }

    static void SetAndroidConfig()
    {
        Hashtable config = LoadCfg();
        if (config != null)
        {
            BuildMode = config["BuildMode"].ToString();
            PlayerSettings.SetScriptingDefineSymbolsForGroup(BuildTargetGroup.Android, config["DefineSymbols"].ToString());

            if (!string.IsNullOrEmpty(config["BundleId"].ToString()))
            {
                BundleId = config["BundleId"].ToString();
            }
            if (!string.IsNullOrEmpty(config["ProductName"].ToString()))
            {
                PlayerSettings.productName = config["ProductName"].ToString();
            }
        }
    }

    static void SetIOSConfig()
    {
        Hashtable config = LoadCfg();
        if (config != null)
        {
            BuildMode = config["BuildMode"].ToString();
            PlayerSettings.SetScriptingDefineSymbolsForGroup(BuildTargetGroup.iOS, config["DefineSymbols"].ToString());

            if (!string.IsNullOrEmpty(config["BundleId"].ToString()))
            {
                BundleId = config["BundleId"].ToString();
            }
            if (!string.IsNullOrEmpty(config["ProductName"].ToString()))
            {
                PlayerSettings.productName = config["ProductName"].ToString();
            }
            if (!string.IsNullOrEmpty(config["TeamID"].ToString()))
            {
                PlayerSettings.iOS.appleDeveloperTeamID = config["TeamID"].ToString();
            }
            if (!string.IsNullOrEmpty(config["ProfileID"].ToString()))
            {
                PlayerSettings.iOS.iOSManualProvisioningProfileID = config["ProfileID"].ToString();
            }
            if (!string.IsNullOrEmpty(config["BuildNumber"].ToString()))
            {
                PlayerSettings.iOS.buildNumber = config["BuildNumber"].ToString();
            } 
        }
    }

    static string BundleId = "com.nkp.game";
    static string m_version = "";
    static string Version
    {
        get
        {
            if (string.IsNullOrEmpty(m_version))
            {
                var infoAssets = Resources.Load("info") as TextAsset;
                m_version = infoAssets.text;
            }
            return m_version;
        }
    }

    static void WriteInfo()
    {
        string version = Version;
        PlayerSettings.bundleVersion = version;
        PlayerSettings.applicationIdentifier = BundleId;
    }
    #endregion

    public static string[] Levels
    {
        get
        {
            string[] scenes = new string[EditorBuildSettings.scenes.Length];
            for (int i = 0; i < EditorBuildSettings.scenes.Length; i++)
            {
                scenes[i] = EditorBuildSettings.scenes[i].path;
            }
            return scenes;
        }
    }

    static string buildMode = "";
    public static string BuildMode
    {
        get
        {
            return buildMode;
        }
        set
        {
            buildMode = value;
        }
    }

    #region 打包IOS程序
    public static void BuildIOSImpl()
    {
        SetIOSConfig();
        WriteInfo();

		//NBuildBundle.ChangeUTF8();

        int index = Application.dataPath.LastIndexOf("/");
        string path = Application.dataPath.Substring(0, index) + "/Build/game_xcode";

        //现在IOS可以采用useMicroMSCorlib 这个属性了，之前听说protobuf不可以
        PlayerSettings.strippingLevel = StrippingLevel.StripAssemblies;

        //采用fast no exception
        PlayerSettings.iOS.scriptCallOptimization = ScriptCallOptimizationLevel.FastButNoExceptions;

        //设置ios最低版本为ios8.0
        PlayerSettings.iOS.targetOSVersionString =  "8.0";

        //修改AOT的参数,否则会出现Ran Out Of Trampolines of Type 2
        PlayerSettings.aotOptions = "nimt-trampolines=256";

        //关闭自动签名
        PlayerSettings.iOS.appleEnableAutomaticSigning = false;

        //清理图集引用关系
        //UIAtlasCleanMaterial.CleanMaterial();

        //修改symlinklibraries 内容
        if (buildMode != "Debug")
        {
            BuildPipeline.BuildPlayer(CommandBuild.Levels, path, BuildTarget.iOS, BuildOptions.SymlinkLibraries);
        }
        else
        {
            BuildPipeline.BuildPlayer(CommandBuild.Levels, path, BuildTarget.iOS, BuildOptions.SymlinkLibraries | BuildOptions.Development | BuildOptions.ConnectWithProfiler); 
        }
        Debug.Log("**** BuildReportTool.ReportGenerator.CreateReport() ****");
        BuildReportTool.ReportGenerator.CreateReport();
    }
    #endregion

    #region 打包安卓程序
    static void AndroidKeystore() 
    {
        try
        {
            PlayerSettings.Android.keystoreName = "CompileScript/Android_KeyStore/kp.keystore";
            PlayerSettings.Android.keystorePass = "90km.com.cn.kp";

            PlayerSettings.Android.keyaliasName = "kp";
            PlayerSettings.keyaliasPass = "90km.com.cn.kp";
            string log = "**** keystoreName : " + PlayerSettings.Android.keystoreName 
                    + " keystorePass : " + PlayerSettings.Android.keystorePass
                    + " keyaliasName : " + PlayerSettings.Android.keyaliasName
                    + " keyaliasPass : " + PlayerSettings.Android.keyaliasPass;
            Debug.Log(log);
        }
        catch (System.Exception ex)
        {
            Debug.LogError("**** Set Android keystore Error! : " + ex.Message);
        }
    }

    public static void BuildAndroidImpl()
    {
        SetAndroidConfig();
        WriteInfo();

		//NBuildBundle.ChangeUTF8();

        AndroidKeystore();

        //android versionCode
        string svnCode = Version.Substring(Version.LastIndexOf(".") + 1);
        PlayerSettings.Android.bundleVersionCode = System.Convert.ToInt32(svnCode);

        Debug.Log("**** versionCode : " + PlayerSettings.Android.bundleVersionCode.ToString());
        PlayerSettings.strippingLevel = StrippingLevel.StripAssemblies;

        //清理图集引用关系
        //UIAtlasCleanMaterial.CleanMaterial();

        if (buildMode != "Debug")
        {
            BuildPipeline.BuildPlayer(CommandBuild.Levels, "./Build/game.apk", BuildTarget.Android, BuildOptions.None);
        }
        else
        {
            BuildPipeline.BuildPlayer(CommandBuild.Levels, "./Build/game.apk", BuildTarget.Android, BuildOptions.Development | BuildOptions.ConnectWithProfiler);
        }
        Debug.Log("**** BuildReportTool.ReportGenerator.CreateReport() ****");
        BuildReportTool.ReportGenerator.CreateReport();
    }
    #endregion
}