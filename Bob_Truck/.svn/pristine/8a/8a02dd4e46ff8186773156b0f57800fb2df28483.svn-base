using System;
using System.Collections;
using UnityEngine;

/// <summary>
/// AssetBundle字节解析器
/// </summary>
public class NAssetBundleParser
{
    public enum CAssetBundleParserMode
    {
        Async,
        Sync,
    }

    /// <summary>
    /// 是异步解析，还是同步解析
    /// </summary>
    public static CAssetBundleParserMode Mode = CAssetBundleParserMode.Sync;

    private bool IsDisposed = false;
    private bool UnloadAllAssets; // Dispose时赋值

    private readonly Action<AssetBundle> Callback;
    public bool IsFinished;
    public AssetBundle Bundle;

    public static Func<string, byte[], byte[]> BundleBytesFilter = null; // 可以放置資源加密函數

    private static int _autoPriority = 1;

    private readonly AssetBundleCreateRequest CreateRequest;

    public float Progress
    {
        get { return CreateRequest.progress; }
    }

    public string RelativePath;

    private readonly float _startTime = 0;

    public NAssetBundleParser(string relativePath, byte[] bytes, Action<AssetBundle> callback = null)
    {
        if (Debug.isDebugBuild)
        {
            _startTime = Time.realtimeSinceStartup;
        }

        Callback = callback;
        RelativePath = relativePath;

        var func = BundleBytesFilter ?? DefaultParseAb;
        var abBytes = func(relativePath, bytes);
        switch (Mode)
        {
            case CAssetBundleParserMode.Async:
                {
                    CreateRequest = AssetBundle.LoadFromMemoryAsync(abBytes);
                    CreateRequest.priority = _autoPriority++; // 后进先出, 一个一个来
                    NManagerResourceModule.Instance.StartCoroutine(WaitCreateAssetBundle(CreateRequest));
                }
                break;
            case CAssetBundleParserMode.Sync:
                OnFinish(AssetBundle.LoadFromMemory(abBytes));
                break;
            default:
                throw new Exception("Error CAssetBundleParserMode: " + Mode);
        }
    }

    private void OnFinish(AssetBundle bundle)
    {
        IsFinished = true;
        Bundle = bundle;

        if (IsDisposed)
            DisposeBundle();
        else
        {
            if (Callback != null)
                Callback(Bundle);
        }

        if (Application.isEditor && Debug.isDebugBuild)
        {
            var useTime = Time.realtimeSinceStartup - _startTime;
            var timeLimit = Mode == CAssetBundleParserMode.Async ? 1f : .3f;
            if (useTime > timeLimit) // 超过一帧时间肯定了
            {
                Debug.LogWarning("[KAssetBundleParser] Parse Too long time: " + RelativePath + ",  used time: " + useTime);
            }
        }
    }

    private IEnumerator WaitCreateAssetBundle(AssetBundleCreateRequest req)
    {
        float startTime = Time.time;

        while (!req.isDone)
        {
            yield return null;
        }

        if (Application.isEditor)
        {
            const float timeout = 5f;
            if (Time.time - startTime > timeout)
            {
                Debug.LogWarning("[CAssetBundlerParser]" + RelativePath + " 解压/读取Asset太久了! 花了" + (Time.time - startTime) + "秒, 超过 " + timeout + "秒");
            }
        }
        OnFinish(req.assetBundle);
    }


    private static byte[] DefaultParseAb(string relativePath, byte[] bytes)
    {
        return bytes;
    }

    private void DisposeBundle()
    {
        Bundle.Unload(UnloadAllAssets);
    }

    public void Dispose(bool unloadAllAssets)
    {
        UnloadAllAssets = unloadAllAssets;
        if (Bundle != null)
            DisposeBundle();
        IsDisposed = true;
    }
}