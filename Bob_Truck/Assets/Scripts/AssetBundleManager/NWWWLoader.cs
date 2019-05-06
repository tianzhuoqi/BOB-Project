using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

/// <summary>
/// Load www, A wrapper of WWW.
/// </summary>
public class NWWWLoader : NAbstractResourceLoader
{
    // 前几项用于监控器
    private static IEnumerator CachedWWWLoaderMonitorCoroutine; // 专门监控WWW的协程
    private const int MAX_WWW_COUNT = 15; // 同时进行的最大Www加载个数，超过的排队等待
    private static int WWWLoadingCount = 0; // 有多少个WWW正在运作, 有上限的

    private static readonly Stack<NWWWLoader> WWWLoadersStack = new Stack<NWWWLoader>();
    // WWWLoader的加载是后进先出! 有一个协程全局自我管理. 后来涌入的优先加载！

    public static event Action<string> WWWFinishCallback;

    public float BeginLoadTime;
    public float FinishLoadTime;
    public UnityWebRequest Www;

    public int Size
    {
        get { return (int)Www.downloadedBytes; }
    }

    public float LoadSpeed
    {
        get
        {
            if (!IsCompleted)
                return 0;
            return Size / (FinishLoadTime - BeginLoadTime);
        }
    }

    //public int DownloadedSize { get { return Www != null ? Www.bytesDownloaded : 0; } }

    /// <summary>
    /// Use this to directly load WWW by Callback or Coroutine, pass a full URL.
    /// A wrapper of Unity's WWW class.
    /// </summary>
    public static NWWWLoader Load(string url, LoaderDelgate callback = null)
    {
        var wwwLoader = AutoNew<NWWWLoader>(url, callback);
        return wwwLoader;
    }

    protected override void Init(string url, params object[] args)
    {
        base.Init(url, args);
        WWWLoadersStack.Push(this); // 不执行开始加载，由www监控器协程控制

        if (CachedWWWLoaderMonitorCoroutine == null)
        {
            CachedWWWLoaderMonitorCoroutine = WWWLoaderMonitorCoroutine();
            NManagerResourceModule.Instance.StartCoroutine(CachedWWWLoaderMonitorCoroutine);
        }
    }

    protected void StartLoad()
    {
        NManagerResourceModule.Instance.StartCoroutine(CoLoad(Url)); //开启协程加载Assetbundle，执行Callback
    }

    /// <summary>
    /// 协和加载Assetbundle，加载完后执行callback
    /// </summary>
    /// <param name="url">资源的url</param>
    /// <param name="callback"></param>
    /// <param name="callbackArgs"></param>
    /// <returns></returns>
    private IEnumerator CoLoad(string url)
    {
        System.DateTime beginTime = System.DateTime.Now;
        // 潜规则：不用LoadFromCache~它只能用在.assetBundle
        Www = UnityWebRequest.Get(NManagerResourceModule.GetFileProtocol() + url);
        BeginLoadTime = Time.time;
        WWWLoadingCount++;
        Www.SendWebRequest();
        //设置AssetBundle解压缩线程的优先级
        //Www.threadPriority = Application.backgroundLoadingPriority; // 取用全局的加载优先速度
        while (!Www.isDone)
        {
            Progress = Www.downloadProgress;
            yield return null;
        }

        WWWLoadingCount--;
        Progress = 1;
        if (IsReadyDisposed)
        {
            Debug.LogError("[KWWWLoader]Too early release: " + url);
            OnFinish(null);
            yield break;
        }
        if (!string.IsNullOrEmpty(Www.error))
        {
            Debug.LogError("[KWWWLoader:Error]" + Www.error + " " + url);

            OnFinish(null);
            yield break;
        }
        else
        {
            if (WWWFinishCallback != null)
                WWWFinishCallback(url);

            Desc = string.Format("{0}K", Www.downloadHandler.data.Length / 1024f);
            OnFinish(Www);
        }

        // 预防WWW加载器永不反初始化, 造成内存泄露~
        if (Application.isEditor)
        {
            while (GetCount<NWWWLoader>() > 0)
                yield return null;

            yield return new WaitForSeconds(5f);

            while (Debug.isDebugBuild && !IsReadyDisposed)
            {
                Debug.LogError("[KWWWLoader]Not Disposed Yet! : " + this.Url);
                yield return null;
            }
        }
    }

    protected override void OnFinish(object resultObj)
    {
        FinishLoadTime = Time.time;
        base.OnFinish(resultObj);
    }

    protected override void DoDispose()
    {
        base.DoDispose();

        Www.Dispose();
        Www = null;
    }


    /// <summary>
    /// 监视器协程
    /// 超过最大WWWLoader时，挂起~
    /// 后来的新loader会被优先加载
    /// </summary>
    /// <returns></returns>
    protected static IEnumerator WWWLoaderMonitorCoroutine()
    {
        //yield return new WaitForEndOfFrame(); // 第一次等待本帧结束
        yield return null;

        while (WWWLoadersStack.Count > 0)
        {
            if (NManagerResourceModule.LoadByQueue)
            {
                while (GetCount<NWWWLoader>() != 0)
                    yield return null;
            }
            while (WWWLoadingCount >= MAX_WWW_COUNT)
            {
                yield return null;
            }

            var wwwLoader = WWWLoadersStack.Pop();
            wwwLoader.StartLoad();
        }

        NManagerResourceModule.Instance.StopCoroutine(CachedWWWLoaderMonitorCoroutine);
        CachedWWWLoaderMonitorCoroutine = null;
    }
}