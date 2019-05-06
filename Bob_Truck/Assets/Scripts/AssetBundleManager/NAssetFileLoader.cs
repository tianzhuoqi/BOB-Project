using System;
using System.Collections;
using System.IO;
using UnityEngine;
using Object = UnityEngine.Object;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class NAssetFileLoader : NAbstractResourceLoader
{
    public delegate void AssetFileBridgeDelegate(bool isOk, Object resultObj);

    public Object Asset
    {
        get { return ResultObject as Object; }
    }

    private bool IsLoadAssetBundle;

    public override float Progress
    {
        get
        {
            if (BundleLoader != null)
                return BundleLoader.Progress;
            return 0;
        }
    }

    public NAssetBundleLoader BundleLoader;

    public static NAssetFileLoader Load(string path, AssetFileBridgeDelegate assetFileLoadedCallback = null, LoaderMode loaderMode = LoaderMode.Async)
    {
        LoaderDelgate realcallback = null;
        if (assetFileLoadedCallback != null)
        {
            realcallback = (isOk, obj) => assetFileLoadedCallback(isOk, obj as Object);
        }

        return AutoNew<NAssetFileLoader>(path, realcallback, false, loaderMode);
    }

    /// <summary>
    /// Check Bundles/[Platform]/xxxx.kk exists?
    /// </summary>
    /// <param name="url"></param>
    /// <returns></returns>
    public static bool IsBundleResourceExist(string url)
    {
        return true;
        /// TODO
        //if (NManagerResourceModule.IsEditorLoadAsset)
        //{
        //    var editorPath = "Assets/" + KEngineDef.ResourcesBuildDir + "/" + url;
        //    var hasEditorUrl = File.Exists(editorPath);
        //    if (hasEditorUrl) return true;
        //}

        //return KResourceModule.IsResourceExist(KResourceModule.BundlesPathRelative + url.ToLower() + AppEngine.GetConfig(KEngineDefaultConfigs.AssetBundleExt));
    }
    protected override void Init(string url, params object[] args)
    {
        var loaderMode = (LoaderMode)args[0];

        base.Init(url, args);
        NManagerResourceModule.Instance.StartCoroutine(_Init(Url, loaderMode));
    }

    private IEnumerator _Init(string path, LoaderMode loaderMode)
    {
        IsLoadAssetBundle = NManagerResourceModule.RunBundle;
        Object getAsset = null;
        /// 编译器模式下 下载本地bunlde
        if (NManagerResourceModule.IsEditorLoadAsset && Application.isEditor)
        {
#if UNITY_EDITOR
            getAsset = AssetDatabase.LoadAssetAtPath(NManagerResourceModule.EditBundlesPathRelative + path, typeof(UnityEngine.Object));
            if (getAsset == null)
            {
                Debug.LogError("Asset is NULL: " + path);
            }
#endif
        }
        else if (!IsLoadAssetBundle)
        {
            string extension = Path.GetExtension(path);
            path = path.Substring(0, path.Length - extension.Length); // remove extensions

            getAsset = Resources.Load<Object>(path);
            if (getAsset == null)
            {
                Debug.LogError("Asset is NULL(from Resources Folder): " + path);
            }
        }
        else
        {
            BundleLoader = NAssetBundleLoader.Load(path, null, loaderMode);

            while (!BundleLoader.IsCompleted)
            {
                if (IsReadyDisposed) // 中途释放
                {
                    BundleLoader.Release();
                    OnFinish(null);
                    yield break;
                }
                yield return null;
            }

            if (!BundleLoader.IsSuccess)
            {
                Debug.LogError("[AssetFileLoader]Load BundleLoader Failed(Error) when Finished: " + path);
                BundleLoader.Release();

                // 最后使用resources下的资源再尝试加载一次
                string extension = Path.GetExtension(path);
                path = path.Substring(0, path.Length - extension.Length); // remove extensions

                getAsset = Resources.Load<Object>(path);
                if (getAsset == null)
                {
                    OnFinish(null);
                }
                else
                {
                    OnFinish(getAsset);
                }
            }
            else
            {
                var assetBundle = BundleLoader.Bundle;

                DateTime beginTime = DateTime.Now;

                // Unity 5 下，不能用mainAsset, 要取对象名
                var abAssetName = Path.GetFileNameWithoutExtension(Url).ToLower();
                if (!assetBundle.isStreamedSceneAssetBundle)
                {
                    if (loaderMode == LoaderMode.Sync)
                    {
                        getAsset = assetBundle.LoadAsset(abAssetName);
                        BundleLoader.PushLoadedAsset(getAsset);
                    }
                    else
                    {
                        var request = assetBundle.LoadAssetAsync(abAssetName);

                        yield return request.asset;

                        getAsset = request.asset;
                        BundleLoader.PushLoadedAsset(getAsset);
                    }
                }
                else
                {
                    // if it's a scene in asset bundle, did nothing
                    // but set a fault Object the result
                    getAsset = NManagerResourceModule.Instance;
                }

                if (getAsset == null)
                {
                    //Debug.LogError("Asset is NULL: path" + path);
                }
            }
        }

        if (Application.isEditor)
        {
            /// TODO
            //if (getAsset != null)
            //    KResoourceLoadedAssetDebugger.Create(getAsset.GetType().Name, Url, getAsset as Object);

            // 编辑器环境下，如果遇到GameObject，对Shader进行Fix
            if (getAsset is GameObject)
            {
                var go = getAsset as GameObject;
                foreach (var r in go.GetComponentsInChildren<Renderer>(true))
                {
                    RefreshMaterialsShaders(r);
                }
            }
        }

        //if (getAsset != null)
        //{
        //    // 更名~ 注明来源asset bundle 带有类型
        //    getAsset.name = String.Format("{0}~{1}", getAsset, Url);
        //}
        OnFinish(getAsset);
    }

    /// <summary>
    /// 编辑器模式下，对指定GameObject刷新一下Material
    /// </summary>
    public static void RefreshMaterialsShaders(Renderer renderer)
    {
        if (renderer.sharedMaterials != null)
        {
            foreach (var mat in renderer.sharedMaterials)
            {
                if (mat != null && mat.shader != null)
                {
                    mat.shader = Shader.Find(mat.shader.name);
                }
            }
        }
    }

    protected override void DoDispose()
    {
        base.DoDispose();

        if (BundleLoader != null)
            BundleLoader.Release(); // 释放Bundle(WebStream)

        //if (IsFinished)
        {
            if (!IsLoadAssetBundle)
            {
                Resources.UnloadUnusedAssets();
            }
            else
            {
                //Object.DestroyObject(ResultObject as UnityEngine.Object);

                // Destroying GameObjects immediately is not permitted during physics trigger/contact, animation event callbacks or OnValidate. You must use Destroy instead.
                //                    Object.DestroyImmediate(ResultObject as Object, true);
            }

            //var bRemove = Caches.Remove(Url);
            //if (!bRemove)
            //{
            //    Log.Warning("[DisposeTheCache]Remove Fail(可能有两个未完成的，同时来到这) : {0}", Url);
            //}
        }
        //else
        //{
        //    // 交给加载后，进行检查并卸载资源
        //    // 可能情况TIPS：两个未完成的！会触发上面两次！
        //}
    }
	
}
