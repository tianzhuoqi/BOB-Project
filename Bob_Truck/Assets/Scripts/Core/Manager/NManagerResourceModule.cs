﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using UnityEngine;
using LuaInterface;
using UnityEngine.Networking;
using com.nkm.common.proto.client;

public enum NResourceQuality
{
    Hd = 1,
    Sd = 2,
    Ld = 4,
}

/// <summary>
/// 资源路径优先级，优先使用
/// </summary>
public enum NResourcePathPriorityType
{
    Invalid,

    /// <summary>
    /// 忽略PersitentDataPath, 优先寻找Resources或StreamingAssets路径 (取决于ResourcePathType)
    /// </summary>
    InAppPathPriority,

    /// <summary>
    /// 尝试在Persistent目錄尋找，找不到再去StreamingAssets,
    /// 这一般用于进行热更新版本号判断后，设置成该属性
    /// </summary>
    PersistentDataPathPriority,
}

public class NManagerResourceModule : NSingleton<NManagerResourceModule>
{
    protected NManagerResourceModule()
    {
        needUpdate = false;
    }

    public static bool LoadByQueue = false;

    public static string ResourceVersion = "1.0.0";

#if UNITY_EDITOR
    public static string CDNPath = "192.168.80.17/";
#else
    public static string CDNPath = "http://47.94.213.46:9090/SD-ResourceFile/";
    //public static string CDNPath = "http://123.207.122.248/SD-ResourceFile/";
#endif
    [NoToLua]
    public static Dictionary<string, string> BundleMD5Info;
    [NoToLua]
    public static Dictionary<string, string> BundleGuidInfo;
    [NoToLua]
    public static Dictionary<string, string> BundlePathInfo;
    [NoToLua]
    public static Dictionary<string, string> ResourceServerBundleMD5Info;
    [NoToLua]
    public static Dictionary<string, string> ResourceServerBundleGuidInfo;
    [NoToLua]
    public static Dictionary<string, string> ResourceServerBundlePathInfo;

    /// <summary>
    /// 是否優先找下載的資源?還是app本身資源優先. 优先下载的资源，即采用热更新的资源
    /// </summary>
    public static NResourcePathPriorityType ResourcePathPriorityType =
        NResourcePathPriorityType.PersistentDataPathPriority;

    /// <summary>
    /// Product Folder Full Path , Default: C:\xxxxx\xxxx\../Product
    /// </summary>
    public static string EditorProductFullPath
    {
        get { return Path.GetFullPath("Assets").Replace("\\", "/"); }
    }

    public static string EditBundlesPathRelative { get; private set; }

    public static string ApplicationPath { get; private set; }

    public static string ProductPathWithProtocol
    {
        get
        {
            return GetFileProtocol() + Application.streamingAssetsPath + "/";
        }
        private set { }
    }

    private static BundleInfoTable bundleInfoTable;

    private static BundleInfoTable resourceServerBundleInfoTable;

    private static bool DirectoryExists(string path)
    {
        string DirectoryPath = "";

        DirectoryPath = Application.persistentDataPath + "/" + path;

        return Directory.Exists(DirectoryPath);
    }

    private static void CreaterDirectory(string path)
    {
        string DirectoryPath = "";
#if UNITY_ANDROID
        DirectoryPath = Application.persistentDataPath + "/" + path;
#else
        DirectoryPath = Application.persistentDataPath + "/" + path;
#endif
        Directory.CreateDirectory(DirectoryPath);
    }

    [NoToLua]
    public static void SetResourceVersion()
    {
        if (UseLocalBundle)
            return;
        UnityWebRequest request = UnityWebRequest.Get(CDNPath + "/ResourceVersion.txt");
        request.SendWebRequest();
        while (true)
        {
            if (request.isDone)
                break;
        }
        ResourceVersion = request.downloadHandler.text;
    }
    [NoToLua]
    public static void AddBundleMD5Info(string bundleName, string md5, string path)
    {
        if (!BundleMD5Info.ContainsKey(bundleName))
            BundleMD5Info.Add(bundleName, md5);
        else
            BundleMD5Info[bundleName] = md5;

        BundleInfo.Builder bundleInfo = BundleInfo.CreateBuilder();
        bundleInfo.SetGuid(bundleName);
        bundleInfo.SetMd5(md5);
        bundleInfo.SetPath(path);
        var bundleinfo = bundleInfo.Build();
        BundleInfo tempBundleInfo = null;
        for (int i = 0; i < bundleInfoTable.DataList.Count; i++)
        {
            if (bundleInfoTable.DataList[i].Path == path)
            {
                tempBundleInfo = bundleInfoTable.DataList[i];
                break;
            }
        }

        BundleInfoTable.Builder tempBundleInfoTable = BundleInfoTable.CreateBuilder(bundleInfoTable);

        if (tempBundleInfo != null)
        {
            tempBundleInfoTable.DataList.Remove(tempBundleInfo);
        }

        tempBundleInfoTable.DataList.Add(bundleinfo);

        bundleInfoTable = tempBundleInfoTable.Build();

        needUpdate = true;
    }

    private static bool needUpdate = false;

    public static void BuildLocalBundleMD5File()
    {
        if (bundleInfoTable != null)
            CreaterFile("assetsBundleInfos.data", bundleInfoTable.ToByteArray());
        needUpdate = false;
    }

    public static string CreaterFile(string path, byte[] bytes)
    {
        string filePath = "";
        filePath = Application.persistentDataPath + "/" + RuntimePlatformDir + "/" + ResourceVersion + "/" + path;
        if (!DirectoryExists("/" + RuntimePlatformDir + "/" + ResourceVersion))
            CreaterDirectory("/" + RuntimePlatformDir + "/" + ResourceVersion);

        if (File.Exists(filePath))
            File.Delete(filePath);

        Stream stream;
        FileInfo file = new FileInfo(filePath);
        stream = file.Create();
        if (bytes != null)
            stream.Write(bytes, 0, bytes.Length);
        stream.Close();
        stream.Dispose();
        return filePath;
    }

    public static string ProductPathWithoutFileProtocol
    {
        get
        {
            return Application.streamingAssetsPath + "/";
        }
        private set { }
    }

    public static string RuntimePlatformDir
    {
        get
        {
#if UNITY_ANDROID
            return "Android";
#else
            return "iOS";
#endif
        }
    }

    public static string ApplicationPersistentDataPath
    {
        get
        {
            return Application.persistentDataPath + "/" + RuntimePlatformDir + "/" + ResourceVersion;
        }
    }

    public static string ApplicationStreamingDataPath
    {
        get
        {
            return Application.streamingAssetsPath + "/" + RuntimePlatformDir + "/" + ResourceVersion;
        }
    }

    public static string DocumentResourcesPathWithoutFileProtocol
    {
        get
        {
            //#if UNITY_EDITOR_WIN
            //            return string.Format("{0}/", Application.persistentDataPath + "/StreamingAssets"); // 各平台通用
            //#elif UNITY_ANDROID
            //            Debug.Log(string.Format("jar:file://{0}/", Application.persistentDataPath + "/!/assets"));
            //            return string.Format("jar:file://{0}/", Application.persistentDataPath + "/!/assets");
            //#endif
            return string.Format("{0}/", Application.persistentDataPath); // 各平台通用
        }
    }

    public static string GetFileProtocol()
    {
        string fileProtocol = "file://";
        if (Application.platform == RuntimePlatform.Android)
            fileProtocol = "file://";
        else if (Application.platform == RuntimePlatform.WindowsEditor ||
            Application.platform == RuntimePlatform.WindowsPlayer
#if !UNITY_2017
                || Application.platform == RuntimePlatform.WindowsWebPlayer
#endif
)
            fileProtocol = "file:///";
        else if (Application.platform == RuntimePlatform.IPhonePlayer)
            fileProtocol = "file://";

        return fileProtocol;
    }

#if UNITY_EDITOR
    public static bool RunBundle = false;
#else
    public static bool RunBundle = true;
#endif

    public static bool UseLocalBundle = true;

    public static void SetRunBundle(bool runbundle)
    {
#if UNITY_EDITOR

#else
        runbundle = true;
#endif
        RunBundle = runbundle;
        IsEditorLoadAsset = !RunBundle;
    }

    public static bool IsEditorLoadAsset = !RunBundle;

    private static void InitResourcePath()
    {
        string editorProductPath = EditorProductFullPath;

        EditBundlesPathRelative = string.Format("{0}/{1}/", "Assets", "ResourcesAssets");

        switch (Application.platform)
        {
            case RuntimePlatform.WindowsEditor:
            case RuntimePlatform.OSXEditor:
                {
                    ApplicationPath = string.Format("{0}{1}", GetFileProtocol(), editorProductPath);
                }
                break;
            case RuntimePlatform.WindowsPlayer:
            case RuntimePlatform.OSXPlayer:
                {
                    //string path = Application.streamingAssetsPath.Replace('\\', '/');
                    ApplicationPath = string.Format("{0}{1}", GetFileProtocol(), Application.dataPath);
                }
                break;
            case RuntimePlatform.Android:
                {
                    ApplicationPath = string.Concat("jar:", GetFileProtocol(), Application.dataPath, "!/assets");
                }
                break;
            case RuntimePlatform.IPhonePlayer:
                {
                    ApplicationPath =
                        System.Uri.EscapeUriString(GetFileProtocol() + Application.streamingAssetsPath); // MacOSX下，带空格的文件夹，空格字符需要转义成%20
                }
                break;
            default:
                {
                    ApplicationPath = "";
                }
                break;
        }
    }

    public static string DocumentResourcesPath
    {
        get
        {
            return GetFileProtocol() + DocumentResourcesPathWithoutFileProtocol;
        }
    }

    /// <summary>
    /// 可被WWW读取的Resource路径
    /// </summary>
    /// <param name="url"></param>
    /// <param name="withFileProtocol">是否带有file://前缀</param>
    /// <param name="newUrl"></param>
    /// <returns></returns>
    public static bool TryGetDocumentResourceUrl(string url, bool withFileProtocol, out string newUrl)
    {
        if (withFileProtocol)
            newUrl = DocumentResourcesPath + url;
        else
            newUrl = DocumentResourcesPathWithoutFileProtocol + url;

        if (UseLocalBundle)
            return false;

        var guid = url.Replace(RuntimePlatformDir + "/" + ResourceVersion + "/", "");
        var path = GetResourceServerBundlePathByGuid(guid);
        var md5 = GetResourceServerBundleMD5ByGuid(guid);

        if (File.Exists(newUrl))
        {
            if (BundleMD5Info.ContainsKey(guid))
            {
                if (BundleMD5Info[guid] != md5)
                {
                    return false;
                }
                else
                    return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
            //DownLodaFile(url, guid);
            //if (File.Exists(newUrl))
            //    return true;
        }
    }

    public static IEnumerator DownLodaFileAsync(string url)
    {
        var guid = url.Replace(RuntimePlatformDir + "/" + ResourceVersion + "/", "");
        var path = GetResourceServerBundlePathByGuid(guid);

        UnityWebRequest www = UnityWebRequest.Get(CDNPath + "/" + url);
        www.SendWebRequest();
        while (!www.isDone)
        {
            yield return null;
        }

        if (string.IsNullOrEmpty(www.error))
        {
            var assetPath = path.Replace(RuntimePlatformDir + "/" + ResourceVersion + "/", "");
            CreaterFile(assetPath, www.downloadHandler.data);

            AddBundleMD5Info(guid, NUtil.md5file(ApplicationPersistentDataPath + "/" + guid), url);
        }
    }

    public static void DownLodaFile(string url)
    {
        var guid = url.Replace(RuntimePlatformDir + "/" + ResourceVersion + "/", "");
        var path = GetResourceServerBundlePathByGuid(guid);

        UnityWebRequest www = UnityWebRequest.Get(CDNPath + "/" + url);
        www.SendWebRequest();
        while (true)
        {
            if (www.isDone)
                break;
        }

        if (string.IsNullOrEmpty(www.error))
        {
            var assetPath = path.Replace(RuntimePlatformDir + "/" + ResourceVersion + "/", "");
            CreaterFile(assetPath, www.downloadHandler.data);

            AddBundleMD5Info(guid, NUtil.md5file(ApplicationPersistentDataPath + "/" + guid), url);
        }
    }

    /// <summary>
    /// 用于GetResourceFullPath函数，返回的类型判断
    /// </summary>
    public enum GetResourceFullPathType
    {
        Invalid,
        InApp,
        InDocument,
    }

    [NoToLua]
    public static void Init()
    {
        SetResourceVersion();
        InitResourcePath();
        InitBundleInfo();
    }

    private static void InitBundleInfo()
    {
        if (RunBundle)
        {
            BundleMD5Info = new Dictionary<string, string>();
            BundleGuidInfo = new Dictionary<string, string>();
            BundlePathInfo = new Dictionary<string, string>();
            ResourceServerBundleMD5Info = new Dictionary<string, string>();
            ResourceServerBundleGuidInfo = new Dictionary<string, string>();
            ResourceServerBundlePathInfo = new Dictionary<string, string>();

            if (UseLocalBundle)
            {
                resourceServerBundleInfoTable = BundleInfoTable.ParseFrom(LoadSyncFromStreamingAssets(ApplicationStreamingDataPath + "/assetsBundleInfos.data"));
                bundleInfoTable = BundleInfoTable.ParseFrom(LoadSyncFromStreamingAssets(ApplicationStreamingDataPath + "/assetsBundleInfos.data"));
            }
            else
            {
                UnityWebRequest request = UnityWebRequest.Get(CDNPath + "/" + RuntimePlatformDir + "/" + ResourceVersion + "/assetsBundleInfos.data");
                request.SendWebRequest();
                while (!request.isDone)
                {
                }
                resourceServerBundleInfoTable = BundleInfoTable.ParseFrom(request.downloadHandler.data);

                if (IsPrsistentDataExists("assetsBundleInfos.data"))
                {
                    UnityWebRequest quest = UnityWebRequest.Get(NManagerResourceModule.GetFileProtocol() + ApplicationPersistentDataPath + "/assetsBundleInfos.data");
                    quest.SendWebRequest();
                    while (!quest.isDone)
                    {
                    }
                    bundleInfoTable = BundleInfoTable.ParseFrom(quest.downloadHandler.data);
                }
                else
                {
                    BundleInfoTable.Builder bundleInfoTableBuild = BundleInfoTable.CreateBuilder();
                    bundleInfoTable = bundleInfoTableBuild.Build();
                    BuildLocalBundleMD5File();
                }
            }

            for (int i = 0; i < bundleInfoTable.DataCount; i++)
            {
                BundleMD5Info.Add(bundleInfoTable.DataList[i].Guid, bundleInfoTable.DataList[i].Md5);
                BundleGuidInfo.Add(bundleInfoTable.DataList[i].Path, bundleInfoTable.DataList[i].Guid);
                BundlePathInfo.Add(bundleInfoTable.DataList[i].Guid, bundleInfoTable.DataList[i].Path);
            }

            for (int i = 0; i < resourceServerBundleInfoTable.DataCount; i++)
            {
                ResourceServerBundleMD5Info.Add(resourceServerBundleInfoTable.DataList[i].Guid, resourceServerBundleInfoTable.DataList[i].Md5);
                ResourceServerBundleGuidInfo.Add(resourceServerBundleInfoTable.DataList[i].Path, resourceServerBundleInfoTable.DataList[i].Guid);
                ResourceServerBundlePathInfo.Add(resourceServerBundleInfoTable.DataList[i].Guid, resourceServerBundleInfoTable.DataList[i].Path);
            }
        }
    }

    /// <summary>
    /// 根据相对路径，获取到StreamingAssets完整路径，或Resources中的路径
    /// </summary>
    /// <param name="url"></param>
    /// <param name="fullPath"></param>
    /// <param name="inAppPathType"></param>
    /// <param name="isLog"></param>
    /// <returns></returns>
    public static GetResourceFullPathType GetResourceFullPath(string url, bool withFileProtocol, out string fullPath,
         bool isLog = true)
    {
        if (string.IsNullOrEmpty(url))
            Debug.LogError("尝试获取一个空的资源路径！");

        string docUrl;
        bool hasDocUrl = TryGetDocumentResourceUrl(url, withFileProtocol, out docUrl);

        string inAppUrl;

        bool hasInAppUrl;
        {
            hasInAppUrl = TryGetInAppStreamingUrl(url, withFileProtocol, out inAppUrl);
        }

        if (ResourcePathPriorityType == NResourcePathPriorityType.PersistentDataPathPriority) // 優先下載資源模式
        {
            fullPath = docUrl;
            if (hasDocUrl)
            {
                return GetResourceFullPathType.InDocument;
            }
            else
            {
                return GetResourceFullPathType.Invalid;
            }
            // 優先下載資源，但又沒有下載資源文件！使用本地資源目錄 
        }

        if (!hasInAppUrl) // 连本地资源都没有，直接失败吧 ？？ 沒有本地資源但又遠程資源？竟然！!?
        {
            UnityWebRequest www = UnityWebRequest.Get(CDNPath + "/" + url);
            www.SendWebRequest();
            while (true)
            {
                if (www.isDone)
                    break;
            }

            if (string.IsNullOrEmpty(www.error))
            {
                CreaterFile(url.Replace(RuntimePlatformDir + "/" + ResourceVersion + "/", ""), www.downloadHandler.data);
                return GetResourceFullPath(url, withFileProtocol, out fullPath, isLog);
            }
            else
            {
                if (isLog)
                    Debug.LogError("[Not Found] StreamingAssetsPath Url Resource: " + url);
                fullPath = null;
                return GetResourceFullPathType.Invalid;
            }
        }

        fullPath = inAppUrl; // 直接使用本地資源！

        return GetResourceFullPathType.InApp;
    }

    /// <summary>
    /// 大小写敏感地进行文件判断, Windows Only
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>
    private static bool FileExistsWithDifferentCase(string filePath)
    {
        if (File.Exists(filePath))
        {
            string directory = Path.GetDirectoryName(filePath);
            string fileTitle = Path.GetFileName(filePath);
            string[] files = Directory.GetFiles(directory, fileTitle);
            var realFilePath = files[0].Replace("\\", "/");
            filePath = filePath.Replace("\\", "/");
            filePath = filePath.Replace("//", "/");

            return String.CompareOrdinal(realFilePath, filePath) == 0;
        }
        return false;
    }

    /// <summary>
    /// (not android ) only! Android资源不在目录！
    /// Editor返回文件系统目录，运行时返回StreamingAssets目录
    /// </summary>
    /// <param name="url"></param>
    /// <param name="withFileProtocol">是否带有file://前缀</param>
    /// <param name="newUrl"></param>
    /// <returns></returns>
    public static bool TryGetInAppStreamingUrl(string url, bool withFileProtocol, out string newUrl)
    {
        if (withFileProtocol)
            newUrl = ProductPathWithProtocol + url;
        else
            newUrl = ProductPathWithoutFileProtocol + url;

        if (UseLocalBundle)
            return true;

        if (!File.Exists(newUrl))
        {
            return false;
        }

        //// 注意，StreamingAssetsPath在Android平台時，壓縮在apk里面，不要做文件檢查了
        //if (!Application.isEditor && Application.platform == RuntimePlatform.Android)
        //{
        //    ///TODO
        //    //if (!KEngineAndroidPlugin.IsAssetExists(url))
        //    //    return false;
        //}
        //else
        //{
        //    // Editor, 非android运行，直接进行文件检查
        //    if (!File.Exists(newUrl))
        //    {
        //        return false;
        //    }
        //}

        // Windows/Edtiro平台下，进行大小敏感判断
        if (Application.isEditor)
        {
            var result = FileExistsWithDifferentCase(ProductPathWithoutFileProtocol + url);
            if (!result)
            {
                Debug.LogError("[大小写敏感]发现一个资源 " + url + "，大小写出现问题，在Windows可以读取，手机不行，请改表修改！");
            }
        }
        return true;
    }

    /// <summary>
    /// check file exists of streamingAssets. On Android will use plugin to do that.
    /// </summary>
    /// <param name="path">relative path,  when file is "file:///android_asset/test.txt", the pat is "test.txt"</param>
    /// <returns></returns>
    public static bool IsStreamingAssetsExists(string path)
    {
        ///TODO
        //if (Application.platform == RuntimePlatform.Android)
        //    return KEngineAndroidPlugin.IsAssetExists(path);
        var fullPath = Path.Combine(ApplicationPath + "/" + RuntimePlatformDir + "/" + ResourceVersion + "/", path);
        return File.Exists(fullPath);
    }

    public static bool IsFileExists(string path)
    {
        if (!RunBundle)
            return File.Exists(Application.dataPath + "/ResourcesAssets/" + path);
        else
        {
            return true;
        }
    }

    public static bool IsPrsistentDataExists(string path)
    {
        ///TODO
        //if (Application.platform == RuntimePlatform.Android)
        //    return KEngineAndroidPlugin.IsAssetExists(path);

        var fullPath = Path.Combine(ApplicationPersistentDataPath + "/", path);
        return File.Exists(fullPath);
    }

    /// <summary>
    /// Load file from streamingAssets. On Android will use plugin to do that.
    /// </summary>
    /// <param name="path">relative path,  when file is "file:///android_asset/test.txt", the pat is "test.txt"</param>
    /// <returns></returns>
    public static byte[] LoadSyncFromStreamingAssets(string path)
    {
        //if (!IsStreamingAssetsExists(path))
        //    throw new Exception("Not exist StreamingAssets path: " + path);
        ///TODO
        //if (Application.platform == RuntimePlatform.Android)
        //    return KEngineAndroidPlugin.GetAssetBytes(path);

        //var fullPath = Path.Combine(ApplicationPath, path);
        //Debug.Log("fullPath = " + fullPath);

#if UNITY_IOS
        return ReadAllBytes(path);
#else
        return WWWReadAllBytes(path);
#endif
    }

    public static byte[] WWWReadAllBytes(string resPath)
    {
        UnityWebRequest www = UnityWebRequest.Get(resPath);
        www.SendWebRequest();
        //WWW www = new WWW(resPath);
        while (!www.isDone)
        {
        }
        if (!string.IsNullOrEmpty(www.error))
        {
            Debug.LogError(www.error);
            return null;
        }

        return www.downloadHandler.data;
    }

    /// <summary>
    /// 无视锁文件，直接读bytes
    /// </summary>
    /// <param name="resPath"></param>
    public static byte[] ReadAllBytes(string resPath)
    {
        byte[] bytes;
        using (FileStream fs = File.Open(resPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
        {
            bytes = new byte[fs.Length];
            fs.Read(bytes, 0, (int)fs.Length);
        }

        return bytes;
    }

    public static void RePreLoadManifest()
    {
        NAssetBundleLoader.RePreLoadManifest();
    }

    /// <summary>
    /// load asset bundle immediatly
    /// </summary>
    /// <param name="path"></param>
    /// <param name="callback"></param>
    /// <returns></returns>
    [NoToLua]
    public static NAbstractResourceLoader LoadBundle(string path, NAssetFileLoader.AssetFileBridgeDelegate callback = null)
    {
        var request = NAssetFileLoader.Load(path, callback, LoaderMode.Sync);
        return request;
    }

    /// <summary>
    /// Load Async Asset Bundle
    /// </summary>
    /// <param name="path"></param>
    /// <param name="callback">cps style async</param>
    /// <returns></returns>
    [NoToLua]
    public static NAbstractResourceLoader LoadBundleAsync(string path, NAssetFileLoader.AssetFileBridgeDelegate callback = null)
    {
        var request = NAssetFileLoader.Load(path, callback);
        return request;
    }

    #region Lua接口
    //Lua内用下面接口,目前只支持GameObject
    public static GameObject LuaLoadBundleAsync(string path, NAssetFileLoader.AssetFileBridgeDelegate callback = null)
    {
        var loader = NAssetFileLoader.Load(path, callback);
        if (null == loader)
            return null;
        return loader.Asset as GameObject;
    }

    public static GameObject LuaLoadBundle(string path, NAssetFileLoader.AssetFileBridgeDelegate callback = null)
    {
        var loader = NAssetFileLoader.Load(path, callback, LoaderMode.Sync);
        if (null == loader)
            return null;
        return loader.Asset as GameObject;
    }
    public static Material LuaLoadBundleMaterial(string path, NAssetFileLoader.AssetFileBridgeDelegate callback = null)
    {

        var loader = NAssetFileLoader.Load(path, callback, LoaderMode.Sync);
        if (null == loader)
            return null;
        return loader.Asset as Material;
    }

    public static Texture LuaLoadBundleTexture(string path, NAssetFileLoader.AssetFileBridgeDelegate callback = null)
    {

        var loader = NAssetFileLoader.Load(path, callback, LoaderMode.Sync);
        if (null == loader)
            return null;
        return loader.Asset as Texture;
    }
    #endregion

    [NoToLua]
    public static string GetBundleGuidByPath(string abPath)
    {
        if (BundleGuidInfo.ContainsKey(abPath))
        {
            return BundleGuidInfo[abPath];
        }
        else
            return abPath;

    }
    [NoToLua]
    public static string GetResourceServerBundlePathByGuid(string guid)
    {
        if (ResourceServerBundleGuidInfo.ContainsKey(guid))
        {
            return ResourceServerBundleGuidInfo[guid];
        }
        else
            return guid;

    }
    [NoToLua]
    public static string GetResourceServerBundleGuidByPath(string abPath)
    {
        if (ResourceServerBundleGuidInfo.ContainsKey(abPath))
        {
            return ResourceServerBundleGuidInfo[abPath];
        }
        else
            return abPath;

    }
    [NoToLua]
    public static string GetBundleMD5ByGuid(string guid)
    {
        if (BundleMD5Info.ContainsKey(guid))
        {
            return BundleMD5Info[guid];
        }
        else
        {
            return guid;
        }
    }

    [NoToLua]
    public static string GetResourceServerBundleMD5ByGuid(string guid)
    {
        if (ResourceServerBundleMD5Info.ContainsKey(guid))
        {
            return ResourceServerBundleMD5Info[guid];
        }
        else
        {
            return guid;
        }
    }

    public static byte[] LoadLocalAssetBundleDataTable()
    {
        byte[] bytes;
#if UNITY_ANDROID
        bytes = WWWReadAllBytes(GetFileProtocol() + Application.streamingAssetsPath + "/" + RuntimePlatformDir + "/" + ResourceVersion + "/assetbundledatatable.lua");
#else
        bytes = ReadAllBytes(GetFileProtocol() + Application.streamingAssetsPath + "/" + RuntimePlatformDir + "/" + ResourceVersion + "/assetbundledatatable.lua");
#endif
        return bytes;
    }

    /// <summary>
    /// Collect all KEngine's resource unused loaders
    /// </summary>
    public static void Collect()
    {
        while (NAbstractResourceLoader.UnUsesLoaders.Count > 0)
            NAbstractResourceLoader.DoGarbageCollect();

        Resources.UnloadUnusedAssets();
        System.GC.Collect();
    }

    protected void OnApplicationQuit()
    {
        if(needUpdate)
            BuildLocalBundleMD5File();
    }
}