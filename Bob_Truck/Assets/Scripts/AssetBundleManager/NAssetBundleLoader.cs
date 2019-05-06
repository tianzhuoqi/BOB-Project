using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using Object = UnityEngine.Object;
/// <summary>
/// 加载模式，同步或异步
/// </summary>
public enum LoaderMode
{
    Async,
    Sync,
}

public class NAssetBundleLoader : NAbstractResourceLoader
{
    public delegate void CAssetBundleLoaderDelegate(bool isOk, AssetBundle ab);

    public static Action<string> NewAssetBundleLoaderEvent;
    public static Action<NAssetBundleLoader> AssetBundlerLoaderErrorEvent;

    private NWWWLoader _wwwLoader;
    private NAssetBundleParser BundleParser;
    //private bool UnloadAllAssets; // Dispose时赋值
    public AssetBundle Bundle
    {
        get { return ResultObject as AssetBundle; }
    }

    private string RelativeResourceUrl;
    private List<UnityEngine.Object> _loadedAssets;

    /// <summary>
    /// AssetBundle加载方式
    /// </summary>
    private LoaderMode _loaderMode;

    /// <summary>
    /// AssetBundle读取原字节目录
    /// </summary>
    //private KResourceInAppPathType _inAppPathType;

    public static NAssetBundleLoader Load(string url, CAssetBundleLoaderDelegate callback = null,
        LoaderMode loaderMode = LoaderMode.Async)
    {

#if UNITY_2017
        //url = url.ToLower();
#endif
        LoaderDelgate newCallback = null;
        if (callback != null)
        {
            newCallback = (isOk, obj) => callback(isOk, obj as AssetBundle);
        }

        // fix bug 资源重复加载 for chenjun
        var abGuid = NManagerResourceModule.GetResourceServerBundleGuidByPath(url);

        var newLoader = AutoNew<NAssetBundleLoader>(abGuid, newCallback, false, loaderMode);

        return newLoader;
    }

#if UNITY_2017
    private static bool _hasPreloadAssetBundleManifest = false;
    private static AssetBundle _mainAssetBundle;
    private static AssetBundleManifest _assetBundleManifest;
    /// <summary>
    /// Unity5下，使用manifest进行AssetBundle的加载
    /// </summary>
    static void PreLoadManifest()
    {
        if (_hasPreloadAssetBundleManifest)
            return;

        _hasPreloadAssetBundleManifest = true;

        // 根据资源版本号获取manifest
#if UNITY_IOS
        HotBytesLoader bytesLoader = HotBytesLoader.Load("iOS/" + NManagerResourceModule.ResourceVersion + "/" + NManagerResourceModule.ResourceVersion, LoaderMode.Sync);
#elif UNITY_ANDROID
        HotBytesLoader bytesLoader = HotBytesLoader.Load("Android/" + NManagerResourceModule.ResourceVersion + "/" + NManagerResourceModule.ResourceVersion, LoaderMode.Sync);
#else
        HotBytesLoader bytesLoader = HotBytesLoader.Load(NManagerResourceModule.ResourceVersion, LoaderMode.Sync);
#endif

        _mainAssetBundle = AssetBundle.LoadFromMemory(bytesLoader.Bytes);
        _assetBundleManifest = _mainAssetBundle.LoadAsset("AssetBundleManifest") as AssetBundleManifest;
    }
#endif

    public static void RePreLoadManifest()
    {
        _hasPreloadAssetBundleManifest = false;
        _mainAssetBundle.Unload(true);
        PreLoadManifest();
    }

    protected override void Init(string url, params object[] args)
    {
#if UNITY_2017
        PreLoadManifest();
#endif
        base.Init(url);

        _loaderMode = (LoaderMode)args[0];

        if (NewAssetBundleLoaderEvent != null)
            NewAssetBundleLoaderEvent(url);

        RelativeResourceUrl = url;
        NManagerResourceModule.Instance.StartCoroutine(LoadAssetBundle(url));
    }

#if UNITY_2017
    /// <summary>
    /// 依赖的AssetBundleLoader
    /// </summary>
    private NAssetBundleLoader[] _depLoaders;
#endif

    private IEnumerator LoadAssetBundle(string relativeUrl)
    {
#if UNITY_2017

        // Unity 5下，自动进行依赖加载
        var abGuid = NManagerResourceModule.GetResourceServerBundleGuidByPath(relativeUrl);

        var deps = _assetBundleManifest.GetAllDependencies(abGuid);
        _depLoaders = new NAssetBundleLoader[deps.Length];
        for (var d = 0; d < deps.Length; d++)
        {
            var dep = deps[d];
            _depLoaders[d] = NAssetBundleLoader.Load(dep, null, _loaderMode);
        }
        for (var l = 0; l < _depLoaders.Length; l++)
        {
            var loader = _depLoaders[l];
            while (!loader.IsCompleted)
            {
                yield return null;
            }
        }
#endif

#if UNITY_2017
        // Unity 5 AssetBundle自动转小写
        //relativeUrl = NManagerResourceModule.GetBundleGuidByPath(relativeUrl.ToLower());
#endif
#if UNITY_ANDROID
        HotBytesLoader bytesLoader = HotBytesLoader.Load("Android/" + NManagerResourceModule.ResourceVersion + "/" + abGuid, _loaderMode);
#else
        HotBytesLoader bytesLoader = HotBytesLoader.Load("iOS/" + NManagerResourceModule.ResourceVersion + "/" + abGuid, _loaderMode);
#endif
        while (!bytesLoader.IsCompleted)
        {
            yield return null;
        }
        if (!bytesLoader.IsSuccess)
        {
            if (AssetBundlerLoaderErrorEvent != null)
            {
                AssetBundlerLoaderErrorEvent(this);
            }
            Debug.LogError("[AssetBundleLoader]Error Load Bytes AssetBundle: " + relativeUrl);
            OnFinish(null);
            yield break;
        }

        byte[] bundleBytes = bytesLoader.Bytes;
        Progress = 1 / 2f;
        bytesLoader.Release(); // 字节用完就释放

        BundleParser = new NAssetBundleParser(RelativeResourceUrl, bundleBytes);
        while (!BundleParser.IsFinished)
        {
            if (IsReadyDisposed) // 中途释放
            {
                OnFinish(null);
                yield break;
            }
            Progress = BundleParser.Progress / 2f + 1 / 2f; // 最多50%， 要算上WWWLoader的嘛
            yield return null;
        }

        Progress = 1f;
        var assetBundle = BundleParser.Bundle;
        if (assetBundle == null)
            Debug.LogError("WWW.assetBundle is NULL: " + RelativeResourceUrl);

        OnFinish(assetBundle);

        //Array.Clear(cloneBytes, 0, cloneBytes.Length);  // 手工释放内存

        //GC.Collect(0);// 手工释放内存
    }

    protected override void OnFinish(object resultObj)
    {
        if (_wwwLoader != null)
        {
            // 释放WWW加载的字节。。释放该部分内存，因为AssetBundle已经自己有缓存了
            _wwwLoader.Release();
            _wwwLoader = null;
        }
        base.OnFinish(resultObj);
    }

    protected override void DoDispose()
    {
        base.DoDispose();

        if (BundleParser != null)
            BundleParser.Dispose(false);
#if UNITY_2017
        foreach (var depLoader in _depLoaders)
        {
            depLoader.Release();
        }
        _depLoaders = null;
#endif

        if (_loadedAssets != null)
        {
            foreach (var loadedAsset in _loadedAssets)
            {
                Object.DestroyImmediate(loadedAsset, true);
            }
            _loadedAssets.Clear();
        }
    }

    public override void Release()
    {
        if (Application.isEditor)
        {
            if (Url.Contains("Arial"))
            {
                Debug.LogError("要释放Arial字体！！错啦！！builtinextra:" + Url);
                //UnityEditor.EditorApplication.isPaused = true;
            }
        }

        base.Release();
    }

    /// 舊的tips~忽略
    /// 原以为，每次都通过getter取一次assetBundle会有序列化解压问题，会慢一点，后用AddWatch调试过，发现如果把.assetBundle放到Dictionary里缓存，查询会更慢
    /// 因为，估计.assetBundle是一个纯Getter，没有做序列化问题。  （不保证.mainAsset）
    public void PushLoadedAsset(Object getAsset)
    {
        if (_loadedAssets == null)
            _loadedAssets = new List<Object>();
        _loadedAssets.Add(getAsset);
    }
	
}
