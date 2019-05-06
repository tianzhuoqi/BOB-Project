﻿using System.Collections;
using System.IO;
using UnityEngine;

/// <summary>
/// 读取字节，调用WWW, 会自动识别Product/Bundles/Platform目录和StreamingAssets路径
/// </summary>
public class HotBytesLoader : NAbstractResourceLoader
{
    public byte[] Bytes { get; private set; }

    /// <summary>
    /// 异步模式中使用了WWWLoader
    /// </summary>
    private NWWWLoader _wwwLoader;

    private LoaderMode _loaderMode;

    public static HotBytesLoader  Load(string path, LoaderMode loaderMode)
    {
        var newLoader = AutoNew<HotBytesLoader>(path, null, false, loaderMode);
        return newLoader;
    }

    private string _fullUrl;

    /// <summary>
    /// Convenient method to load file sync auto.
    /// </summary>
    /// <param name="url"></param>
    /// <returns></returns>
    public static byte[] LoadSync(string url)
    {
        string fullUrl;

        var getResPathType = NManagerResourceModule.GetResourceFullPath(url, false, out fullUrl);

        if (getResPathType == NManagerResourceModule.GetResourceFullPathType.Invalid)
        {
            NManagerResourceModule.DownLodaFile(url);
        }

        return NManagerResourceModule.ReadAllBytes(fullUrl);

        //byte[] bytes;
        //if (getResPathType == NManagerResourceModule.GetResourceFullPathType.InApp)
        //{
        //    if (Application.isEditor) // Editor mode : 读取Product配置目录
        //    {
        //        var loadSyncPath = Path.Combine(NManagerResourceModule.ProductPathWithoutFileProtocol, url);
        //        bytes = NManagerResourceModule.ReadAllBytes(loadSyncPath);
        //    }
        //    else // product mode: read streamingAssetsPath
        //    {
        //        bytes = NManagerResourceModule.LoadSyncFromStreamingAssets(Path.Combine(NManagerResourceModule.ApplicationPath, url));
        //    }
        //}
        //else
        //{
        //    bytes = NManagerResourceModule.ReadAllBytes(fullUrl);
        //}
        //return bytes;
    }

    private IEnumerator CoLoad(string url)
    {
        if (_loaderMode == LoaderMode.Sync)
        {
            Bytes = LoadSync(url);
        }
        else
        {
            NManagerResourceModule.GetResourceFullPathType getResPathType;
            if (Application.isEditor)
            {
                getResPathType = NManagerResourceModule.GetResourceFullPath(url, !Application.isEditor, out _fullUrl);
            }
            else
                getResPathType = NManagerResourceModule.GetResourceFullPath(url, false, out _fullUrl);
            
            if (getResPathType == NManagerResourceModule.GetResourceFullPathType.Invalid)
            {
                yield return NManagerResourceModule.DownLodaFileAsync(url);
            }

            _wwwLoader = NWWWLoader.Load(_fullUrl);
            while (!_wwwLoader.IsCompleted)
            {
                Progress = _wwwLoader.Progress;
                yield return null;
            }

            if (!_wwwLoader.IsSuccess)
            {
                //if (AssetBundlerLoaderErrorEvent != null)
                //{
                //    AssetBundlerLoaderErrorEvent(this);
                //}
                Debug.LogError("[HotBytesLoader]Error Load WWW: " + url);
                Debug.LogError("[HotBytesLoader]Error Load _fullUrl: " + _wwwLoader.Www.error);
                Debug.LogError("[HotBytesLoader]Error Load _fullUrl: " + _fullUrl);

                OnFinish(null);
                yield break;
            }

            Bytes = _wwwLoader.Www.downloadHandler.data;

        }

        OnFinish(Bytes);
    }

    protected override void DoDispose()
    {
        base.DoDispose();
        if (_wwwLoader != null)
        {
            _wwwLoader.Release();
        }
    }

    protected override void Init(string url, params object[] args)
    {
        base.Init(url, args);

        _loaderMode = (LoaderMode)args[0];
        NManagerResourceModule.Instance.StartCoroutine(CoLoad(url));

    }
}
