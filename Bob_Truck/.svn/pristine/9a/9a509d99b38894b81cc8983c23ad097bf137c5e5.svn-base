using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 负责控制和加载UniWebView插件
/// </summary>
public class NWebViewObject : MonoBehaviour 
{
#if UNITY_IOS || UNITY_ANDROID
    private UniWebView m_webView;

    void OnDestroy()
    {
        CloseWebView();
    }

    void CloseWebView()
    {
        if (m_webView != null)
        {
            m_webView.Hide(true, UniWebViewTransitionEdge.Bottom, 0.4f, () => {
                Destroy(m_webView);
                m_webView = null;
            });
            
            //清理缓存,会导致每次重新加载页面,以后遇到问题可以考虑开启这个接口
            //webView.CleanCache();
            NDebug.LogInfo("NWebViewObject CloseWebView");
        }
    }

	public void LoadWebByUrl (string url) 
    {
        //iOS系统H5播放视频需要调用这个接口
        UniWebView.SetAllowInlinePlay(true);

        if (m_webView != null)
        {
            m_webView.Load(url);
        }
        else
        {
            GameObject webViewGameObject = new GameObject("WebView");
            webViewGameObject.transform.parent = gameObject.transform;

            UniWebView webView = webViewGameObject.AddComponent<UniWebView>();
            webView.Frame = new Rect(0, 0, Screen.width, Screen.height);
            webView.SetShowToolbar(false);

            webView.OnPageFinished += OnPageFinished;
            webView.OnPageErrorReceived += OnPageErrorReceived;
            webView.OnMessageReceived += OnMessageReceived;
            webView.OnShouldClose += OnShouldClose;

            m_webView = webView;
            m_webView.Load(url);
        }
        m_webView.Show(true, UniWebViewTransitionEdge.Bottom, 0.4f, () => { });
        NDebug.LogInfo("NWebViewObject LoadWebByUrl Finish url = {0}", url);
	}

    void OnPageFinished(UniWebView webView, int statusCode, string url)
    {
        NDebug.LogInfo("NWebViewObject OnPageFinished");
    }

    void OnMessageReceived(UniWebView webView, UniWebViewMessage message)
    {
        NDebug.LogInfo("NWebViewObject OnMessageReceived, message.Path = {0}", message.Path);
        switch (message.Path)
        {
            case "close":
                {
                    CloseWebView();
                }
                break;
            case "goback":
                {
                    webView.GoBack();
                }
                break;
            case "reload":
                {
                    webView.Reload();
                }
                break;
            default:
                break;
        }
    }

    bool OnShouldClose(UniWebView webView)
    {
        CloseWebView();
        return true;
    }

    void OnPageErrorReceived(UniWebView webView, int errorCode, string errorMessage)
    {
        //发生错误后直接删除,避免出现更多问题
        NDebug.LogError("Something wrong in webview loading: " + errorMessage);
        if (m_webView != null)
        {
            Destroy(m_webView);
            m_webView = null;
        }
    }
#endif
}
