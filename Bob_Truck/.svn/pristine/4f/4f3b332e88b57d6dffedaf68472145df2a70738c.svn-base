using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using LuaInterface;

/// <summary>
/// NGUI中UIPANEL的主类
/// </summary>
public class NUIPanelBase : MonoBehaviour
{
    [NoToLua]
    public int defaultDepth { get ; set; }

	protected UIPanel viewPanel;
    //搜索其他可能挂载的PANEL
    private List<UIPanel> others = new List<UIPanel>();
    private List<int> othersDepth = new List<int>();

    //为了保证Awake的执行，默认不能SetActive(false)

    protected void Awake()
    {
        viewPanel = gameObject.GetComponent<UIPanel>();
        if (viewPanel == null)
        {
            string str = string.Format("{0} is not a panel, please check it", gameObject.name);
            NDebug.LogError(str);
            return;
        }
        others.Clear();
        othersDepth.Clear();

        viewPanel.renderQueue = UIPanel.RenderQueue.StartAt;
        UIPanel[] tempothers = viewPanel.GetComponentsInChildren<UIPanel>(true);
        for (int i = 0; i < tempothers.Length; ++i)
        {
            if (tempothers[i] != viewPanel)
            {
                tempothers[i].renderQueue = UIPanel.RenderQueue.StartAt;
                others.Add(tempothers[i]);
                othersDepth.Add(tempothers[i].depth);
            }
        }
    }

    [NoToLua]
	public void SetActive(bool active)
	{
        if (!gameObject.activeSelf) gameObject.SetActive(active);
        viewPanel.alpha = active ? 1 : 0;
	}

    /// <summary>
    /// Startings the Render Queue.
    /// </summary>
    /// <param name="num">默认从0开始，每次涨200</param>
    [NoToLua]
    public void StartingRQueue(int num)
    {
        if (defaultDepth == 0)
            num += 3000;

        viewPanel.depth = num;
        viewPanel.startingRenderQueue = num;

        for (int i = 0; i < others.Count; i++)
        {
            others[i].depth = viewPanel.depth + othersDepth[i];
            others[i].startingRenderQueue = others[i].depth;
        }
    }

    #region panel的操作目前只有这4个
    [NoToLua]
    public virtual void OpenPanel()
    {
    }

    [NoToLua]
    public virtual void ReopenPanel()
    {
    }

    [NoToLua]
    public virtual void ClosePanel()
    {
    }

    [NoToLua]
    public virtual void DestroyPanel()
    {

    }
    #endregion
}
