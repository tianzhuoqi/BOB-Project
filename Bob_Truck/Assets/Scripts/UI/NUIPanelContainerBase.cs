﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System;
using System.Linq;
using LuaInterface;

//PANEL绑定的锚点
public enum EPanelAnchorSide
{
    EAS_TOP = 0,
    EAS_CENTER,
    EAS_BOTTOM,
    EAS_LEFT,
    EAS_RIGHT,
    EAS_LEFTTOP,
    EAS_LEFTBOTTOM,
    EAS_RIGHTTOP,
    EAS_RIGHTBOTTOM,
}

//开启PANEL的模式
public enum EPanelRunMode
{
    EPRM_Init = 0,      //Init和HomePage都是标记无法被清理的mode
    EPRM_HomePage,      //主页,主要用在反复back的时候判断
    EPRM_Replace,       //不清理data
    EPRM_OverLayer,     //不清理data
    EPRM_Tap,           //EPRM_Replace + 清理data
    EPRM_Back,          //清理data
    EPRM_BackTwoPanel,  //回退两次,清理data
    EPRM_Destroy,       //销毁窗口,清理data
}

//panel显示时遮挡类型(遮挡个人信息、菜单和聊天栏)
public enum EPanelActiveType
{
    EPAT_None = 0,  //遮挡全部，都不显示
    EPAT_Player = 1,//显示顶部的个人信息panel
    EPAT_Menu = 2,  //显示下方的菜单panel
    EPAT_Chat = 3,  //显示聊天栏panel
    EPAT_PlayerAndMenu = 4,//显示顶部的个人信息panel和下方的菜单panel
    EPAT_PlayerAndChat = 5,
    EPAT_ChatAndMenu = 6,
    EPAT_All = 7,//全部显示
}

public class PanelInfo
{
    public string panelpath;
    public string panelname;
    public int depth;
    public Vector3 panelpos = Vector3.zero;
    public int side = 1;    //EPanelAnchorSide.EAS_CENTER
}

public class NUIPanelContainerBase : MonoBehaviour
{
    protected const string pHomePage = "PHomePage";               //设置主界面
    protected const string pInit = "PInit";

    protected const string pName = "PName";
    protected const string pMode = "PMode";
    protected const string pDoubleOpen = "PDoubleOpen";
    protected const string pDoubleOpenNew = "PDoubleOpenNew";
    protected const string pDirect = "PDirect";                   //前往，跳转等功能使用

    protected const int depthInterval = 200;                      //depth之间的间隔

    private List<string> _listPlayer = new List<string>();
    private List<string> _listMenu = new List<string>();
    private List<string> _listChat = new List<string>();
    private List<string> _listNoMove = new List<string>();

    private const string pUIPlayerResourcePanel = "UIPlayerResourcePanel";
    private const string pUIMenuPanel = "UIMenuPanel";
    private const string pUIChatPanel = "UIChatPanel";

    /// <summary>
    /// 9个锚点
    /// </summary>
    [NoToLua]
    public GameObject _panelCenterParent;
    [NoToLua]
    public GameObject _panelTopParent;
    [NoToLua]
    public GameObject _panelBottomParent;
    [NoToLua]
    public GameObject _panelLeftParent;
    [NoToLua]
    public GameObject _panelRightParent;
    [NoToLua]
    public GameObject _panelLeftTopParent;
    [NoToLua]
    public GameObject _panelLeftBottomParent;
    [NoToLua]
    public GameObject _panelRightTopParent;
    [NoToLua]
    public GameObject _panelRightBottomParent;

    protected int _panelZorder = 0;

    private NDictionary _panelMap = new NDictionary();
    private NDictionary _panelPathMap = new NDictionary();

    protected void Awake()
    {
        AddCurrentPanelData(EPanelRunMode.EPRM_Init, pInit);
        _listPlayer.Add(pHomePage);
        _listMenu.Add(pHomePage);
        _listChat.Add(pHomePage);
    }

    protected void OnDestroy()
    {
        _panelMap.Clear();
        _panelPathMap.Clear();
        _runPanelDataList.Clear();

        _listPlayer.Clear();
        _listMenu.Clear();
        _listChat.Clear();
        _listNoMove.Clear();
    }

    #region 窗口管理逻辑(注册，开关底层)
    protected virtual void RunPanel(EPanelRunMode runMode, string newName = "")
    {
        switch (runMode)
        {
            case EPanelRunMode.EPRM_Replace:
                {
                    string oldPanelName = CurrentPanelData<string>(pName);
                    if (oldPanelName != null)
                        ClosePanelByName(oldPanelName, true);

                    AddCurrentPanelData(runMode, newName);
                    OpenPanelByName(newName);
                    break;
                }
            case EPanelRunMode.EPRM_OverLayer:
                {
                    string panelName = CurrentPanelData<string>(pName);
                    if (panelName == newName)
                    {
                        string str = string.Format("RunPanel Error! Panel {0} is runing, pls look it!", newName);
                        NDebug.LogError(str);
                        return;
                    }
                    if (panelName != pInit)
                    {
                        NUIPanelBase panel = PanelByName(panelName);
                        if (panel != null)
                        {
                            //panel.SetActive(false);
                        }
                    }

                    AddCurrentPanelData(runMode, newName);
                    OpenPanelByName(newName);
                    break;
                }
            case EPanelRunMode.EPRM_Tap:
                {
                    string oldPanelName = CurrentPanelData<string>(pName);
                    if (oldPanelName != null)
                    {
                        ClosePanelByName(oldPanelName);
                        RemoveCurrentPanelData();
                    }
                    AddCurrentPanelData(runMode, newName);
                    OpenPanelByName(newName);
                    break;
                }
            case EPanelRunMode.EPRM_Destroy:
            case EPanelRunMode.EPRM_Back:
                {
                    string oldPanelName = CurrentPanelData<string>(pName);
                    if (oldPanelName != null)
                    {
                        if (oldPanelName == pHomePage || oldPanelName == pInit)
                        {
                            //遇到homepage和init后就不能再操作了
                            break;
                        }

                        if (runMode.Equals(EPanelRunMode.EPRM_Back))
                            ClosePanelByName(oldPanelName);
                        else
                            DestroyPanelByName(oldPanelName);
                        RemoveCurrentPanelData();
                    }

                    oldPanelName = CurrentPanelData<string>(pName);
                    if (oldPanelName != null)
                    {
                        ReOpenPanelByName(oldPanelName);
                    }
                    break;
                }
            case EPanelRunMode.EPRM_BackTwoPanel:
                {
                    string oldPanelName = CurrentPanelData<string>(pName);
                    if (oldPanelName != null)
                    {
                        ClosePanelByName(oldPanelName);
                        RemoveCurrentPanelData();
                    }

                    oldPanelName = CurrentPanelData<string>(pName);
                    if (oldPanelName != null)
                    {
                        ClosePanelByName(oldPanelName);
                        RemoveCurrentPanelData();
                    }

                    oldPanelName = CurrentPanelData<string>(pName);
                    if (oldPanelName != null)
                    {
                        ReOpenPanelByName(oldPanelName);
                    }
                    break;
                }
            default:
                break;
        }
        SetBasePanelDepth();
    }

    //设置最底层的个人信息、菜单、聊天框的界面层级
    private void SetBasePanelDepth()
    {
        string panelName = TopPanelName();
        if (_listPlayer.Contains(panelName))
            ChangePanelDepth(pUIPlayerResourcePanel, 100);
        else if (!_listNoMove.Contains(panelName))
            ChangePanelDepth(pUIPlayerResourcePanel, -250);
        
        if (_listMenu.Contains(panelName))
            ChangePanelDepth(pUIMenuPanel, 100);
        else if (!_listNoMove.Contains(panelName))
            ChangePanelDepth(pUIMenuPanel, -250);
        /*
        if (_listChat.Contains(panelName))
            ChangePanelDepth(pUIChatPanel, 100);
        else if (!_listNoMove.Contains(panelName))
            ChangePanelDepth(pUIChatPanel, -250);
         */
    }

    protected NUIPanelBase PanelByName(string name)
    {
        if (_panelMap.HaveKey(name))
            return _panelMap.Value<NUIPanelBase>(name);
        else
        {
            if (_panelPathMap.HaveKey(name))
            {
                PanelInfo info = _panelPathMap.Value<PanelInfo>(name);

                GameObject tempobj = null;
                NAbstractResourceLoader loader = NManagerResourceModule.LoadBundle(info.panelpath);
                tempobj = loader.ResultObject as GameObject;

                GameObject temppanel = GameObject.Instantiate(tempobj);
                if (temppanel == null)
                    NDebug.LogError("RegisterPanelByPerfabPath obj is null! name = " + name);
                temppanel.name = name;
                NUIPanelBase nbase = temppanel.GetComponent<NUIPanelBase>();
                RegisterPanel(nbase, info.panelpos, info.depth, info.side);

                loader.Release();
                return _panelMap.Value<NUIPanelBase>(name);
            }
            else if (name != pHomePage && name != pInit)
            {
                NDebug.LogError("have no panel! name = {0}", name);
            }
            return null;
        }
    }

    protected GameObject GameObjectByName(string name)
    {
        NUIPanelBase pannel = PanelByName(name);
        if (pannel)
            return pannel.gameObject;
        else
            return null;
    }

    protected void RegisterPanel(NUIPanelBase panel, Vector3 local_pos, int settled_depth, int side)
    {
        if (!_panelMap.HaveKey(panel.gameObject.name))
        {
            _panelMap.Push(panel.gameObject.name, panel);

            panel.defaultDepth = settled_depth;

            UIPanel ui = panel.GetComponent<UIPanel>();
            ui.renderQueue = UIPanel.RenderQueue.StartAt;
            ui.startingRenderQueue = settled_depth;
            ui.depth = settled_depth;

            EPanelAnchorSide anchorside = (EPanelAnchorSide)side;
            if (anchorside == EPanelAnchorSide.EAS_BOTTOM && _panelBottomParent)
                panel.gameObject.transform.parent = _panelBottomParent.transform;
            else if (anchorside == EPanelAnchorSide.EAS_TOP && _panelTopParent)
                panel.gameObject.transform.parent = _panelTopParent.transform;
            else if (anchorside == EPanelAnchorSide.EAS_LEFT && _panelLeftParent)
                panel.gameObject.transform.parent = _panelLeftParent.transform;
            else if (anchorside == EPanelAnchorSide.EAS_RIGHT && _panelRightParent)
                panel.gameObject.transform.parent = _panelRightParent.transform;
            else if (anchorside == EPanelAnchorSide.EAS_LEFTTOP && _panelLeftTopParent)
                panel.gameObject.transform.parent = _panelLeftTopParent.transform;
            else if (anchorside == EPanelAnchorSide.EAS_RIGHTTOP && _panelRightTopParent)
                panel.gameObject.transform.parent = _panelRightTopParent.transform;
            else if (anchorside == EPanelAnchorSide.EAS_LEFTBOTTOM && _panelLeftBottomParent)
                panel.gameObject.transform.parent = _panelLeftBottomParent.transform;
            else if (anchorside == EPanelAnchorSide.EAS_RIGHTBOTTOM && _panelRightBottomParent)
                panel.gameObject.transform.parent = _panelRightBottomParent.transform;
            else
                panel.gameObject.transform.parent = _panelCenterParent.transform;

            panel.gameObject.transform.localPosition = local_pos;
            panel.gameObject.transform.localScale = new Vector3(1, 1, 1);
        }
        else
        {
            string str = string.Format("this Panel {0} has loaded!", panel.gameObject.name);
            NDebug.LogError(str);
        }
    }

    /// <summary>
    /// 注册不创建panel接口
    /// </summary>
    /// <param name="name"></param>
    /// <param name="path"></param>
    /// <param name="initPos"></param>
    /// <param name="settled_depth"></param>
    /// <param name="side"></param>
    public void RegisterPanelByPrefabPath(string name, string path, Vector3 initPos, int settled_depth, int side,int panelActiveType)
    {
        if (!_panelPathMap.HaveKey(name))
        {
            PanelInfo panelinfo = new PanelInfo();
            panelinfo.panelname = name;
            panelinfo.panelpos = initPos;
            panelinfo.panelpath = string.Format("{0}/{1}.prefab", path, name);
            panelinfo.side = side;
            panelinfo.depth = settled_depth;
            _panelPathMap.Push(name, panelinfo);
            SavePanelActiveRelation(name, (EPanelActiveType)panelActiveType);
        }
    }

    private void SavePanelActiveRelation(string panelName,EPanelActiveType panelActive)
    {
        switch(panelActive)
        {
            case EPanelActiveType.EPAT_None:
                {
                    _listNoMove.Add(panelName);
                    break;
                }
            case EPanelActiveType.EPAT_Player:
                {
                    _listPlayer.Add(panelName);
                    break;
                }
            case EPanelActiveType.EPAT_Menu:
                {
                    _listMenu.Add(panelName);
                    break;
                }
            case EPanelActiveType.EPAT_Chat:
                {
                    _listChat.Add(panelName);
                    break;
                }
            case EPanelActiveType.EPAT_PlayerAndMenu:
                {
                    _listPlayer.Add(panelName);
                    _listMenu.Add(panelName);
                    break;
                }
            case EPanelActiveType.EPAT_PlayerAndChat:
                {
                    _listPlayer.Add(panelName);
                    _listChat.Add(panelName);
                    break;
                }
            case EPanelActiveType.EPAT_ChatAndMenu:
                {
                    _listMenu.Add(panelName);
                    break;
                }
            case EPanelActiveType.EPAT_All:
                {
                    _listChat.Add(panelName);
                    _listMenu.Add(panelName);
                    _listPlayer.Add(panelName);
                    break;
                } 
        }
    }

    public void ChangePanelDepth(string panelName, int adddepth)
    {
        if (adddepth > 200)
        {
            NDebug.LogError("ChangePanelDepth error adddepth : " + adddepth);
            return;
        }

        NUIPanelBase panel = PanelByName(panelName);
        if (panel)
        {
            int z = _panelZorder + adddepth;
            panel.StartingRQueue(z);
        }
    }

    private void OpenPanelByName(string panelName)
    {
        NUIPanelBase panel = PanelByName(panelName);
        if (panel)
        {
            panel.SetActive(true);
            if (panel.defaultDepth == 0)
            {
                _panelZorder += 200;
                panel.StartingRQueue(_panelZorder);
                panel.OpenPanel();
            }
            else
            {
                panel.StartingRQueue(panel.defaultDepth);
                panel.OpenPanel();
            }
        }
    }

    private void ReOpenPanelByName(string panelName)
    {
        NUIPanelBase panel = PanelByName(panelName);
        if (panel)
        {
            panel.StartingRQueue(_panelZorder);
            panel.SetActive(true);
            panel.ReopenPanel();
        }
    }

    private void ClosePanelByName(string panelName, bool isreplace = false)
    {
        NUIPanelBase panel = PanelByName(panelName);
        if (panel)
        {
            panel.ClosePanel();
            panel.SetActive(false);
            if (panel.defaultDepth == 0 && !isreplace)
            {
                _panelZorder -= depthInterval;
                panel.StartingRQueue(_panelZorder);
            }
        }
    }

    private void DestroyPanelByName(string panelName)
    {
        NUIPanelBase panel = PanelByName(panelName);
        if (panel && _panelMap.HaveKey(panelName))
        {
            _panelMap.Remove(panelName);
            panel.DestroyPanel();
            Destroy(panel.gameObject);
            _panelZorder -= depthInterval;
        }
    }

    protected GameObject CurrentPanelObject()
    {
        string panelName = CurrentPanelData<string>(pName);
        return GameObjectByName(panelName);
    }

    protected NUIPanelBase CurrentPanel()
    {
        string name = CurrentPanelData<string>(pName);
        return PanelByName(name);
    }

    /// <summary>
    /// 打开通用UI
    /// </summary>
    public void OpenUtilityPanel(string name)
    {
        OpenPanelByName(name);
    }

    /// <summary>
    /// 关闭通用UI
    /// </summary>
    public void CloseUtilityPanel(string name)
    {
        ClosePanelByName(name);
    }
    #endregion

    #region 对panel数据结构的操作，原理和堆栈一样，先进后出的原则
    protected List<NDictionary> _runPanelDataList = new List<NDictionary>();
    public string TopPanelName()
    {
        return CurrentPanelData<string>(pName);
    }

    /// <summary>
    /// 获取当前的panel data
    /// </summary>
    protected T CurrentPanelData<T>(string key)
    {
        try
        {
            NDictionary panelData = _runPanelDataList[_runPanelDataList.Count - 1];
            return panelData.Value<T>(key);
        }
        catch
        {
            string str = string.Format("CurrentPanelData {0} error!", key);
            NDebug.LogError(str);
            return default(T);
        }
    }

    protected NDictionary CurrentPanelData()
    {
        return _runPanelDataList[_runPanelDataList.Count - 1];
    }

    /// <summary>
    /// 移除当前的panel data
    /// </summary>
    protected void RemoveCurrentPanelDataKey(string key)
    {
        try
        {
            NDictionary data = _runPanelDataList[_runPanelDataList.Count - 1];
            data.Remove(key);
        }
        catch (System.Exception error)
        {
            string str = string.Format("RemoveCurrentPanelDataKey (key:{0}) error {1}!", key, error.Message);
            NDebug.LogError(str);
        }
    }

    protected void RemoveCurrentPanelData()
    {
        try
        {
            int index = _runPanelDataList.Count - 1;
            NDictionary intent = _runPanelDataList[index];
            string pname = intent.Value<string>(pName);
            if (!pname.Equals(pHomePage) && !pname.Equals(pInit))
                _runPanelDataList.RemoveAt(_runPanelDataList.Count - 1);
        }
        catch
        {
            NDebug.LogError("RemoveCurrentPanelData error!");
        }
    }

    /// <summary>
    /// 是否包含key
    /// </summary>
    protected bool TryCurrentPanelDataKey(string key)
    {
        try
        {
            NDictionary panelData = _runPanelDataList[_runPanelDataList.Count - 1];
            return panelData.HaveKey(key);
        }
        catch (System.Exception error)
        {
            string str = string.Format("TryCurrentPanelDataKey (key:{0}) error {1}!", key, error.Message);
            NDebug.LogError(str);
            return false;
        }
    }

    /// <summary>
    /// 添加当前的data
    /// </summary>
    protected void AddCurrentPanelData(EPanelRunMode runMode, string newName)
    {
        NDictionary data = new NDictionary();

        if (!data.HaveKey(pName))
            data.Push(pName, newName);

        if (!data.HaveKey(pMode))
            data.Push(pMode, runMode);

        for (int i = 0; i < _runPanelDataList.Count; ++i)
        {
            if (_runPanelDataList[i].Value<string>(pName).Equals(newName))
            {
                _runPanelDataList[i].Push(pDoubleOpen, "");
                data.Push(pDoubleOpenNew, "");
                break;
            }
        }
        _runPanelDataList.Add(data);
    }
    #endregion

    #region 对PANEL的开关操作
    public virtual void OverLayerPanel(string panelName = "")
    {
        RunPanel(EPanelRunMode.EPRM_OverLayer, panelName);
    }

    public virtual void ReplacePanel(string panelName = "")
    {
        RunPanel(EPanelRunMode.EPRM_Replace, panelName);
    }

    public virtual void TapPanel(string panelName = "")
    {
        RunPanel(EPanelRunMode.EPRM_Tap, panelName);
    }

    public virtual void DestroyPanel()
    {
        RunPanel(EPanelRunMode.EPRM_Destroy);
    }

    public virtual void BackPanel()
    {
        RunPanel(EPanelRunMode.EPRM_Back);
    }

    public virtual void BackTwoPanel()
    {
        RunPanel(EPanelRunMode.EPRM_BackTwoPanel);
    }

    public virtual void BackMorePanel(string panelName)
    {
        string curPanelName = "";
        do
        {
            curPanelName = TopPanelName();
            if (panelName == curPanelName
                || panelName == pHomePage
                || panelName == pInit
                || curPanelName == pHomePage
                || curPanelName == pInit
                || string.IsNullOrEmpty(curPanelName))
            {
                break;
            }
            ClosePanelByName(curPanelName);
            RemoveCurrentPanelData();
        }
        while (true);

        if (panelName == curPanelName)
        {
            ReOpenPanelByName(panelName);
        }
    }

    public virtual void SetHomePagePoint()
    {
        AddCurrentPanelData(EPanelRunMode.EPRM_HomePage, pHomePage);
    }

    public virtual void ReturnHomePage()
    {
        string panelName = CurrentPanelData<string>(pName);
        while (panelName != pHomePage && panelName != null)
        {
            NUIPanelBase panel = PanelByName(panelName);
            panel.SetActive(true);
            ClosePanelByName(panelName);
            RemoveCurrentPanelData();
            panelName = CurrentPanelData<string>(pName);
        }
    }

    public virtual bool IsRunPanel(string panelName)
    {
        for (int i = 0; i < _runPanelDataList.Count; ++i)
        {
            if (_runPanelDataList[i].Value<string>(pName) == panelName)
                return true;
        }
        return false;
    }

    public bool OldPanelHaveDirect()
    {
        var data = CurrentPanelData();
        if (data != null)
        {
            return data.HaveKey(pDirect) || data.HaveKey(pDoubleOpenNew);
        }
        return false;
    }
    #endregion

    #region webview相关
    
    #if UNITY_IOS || UNITY_ANDROID
    NWebViewObject webViewObj = null;
    #endif

    public bool LoadWebByUrl(string url)
    {
        #if UNITY_IOS || UNITY_ANDROID
        if (webViewObj == null)
        {
            NAbstractResourceLoader loader = NManagerResourceModule.LoadBundle("UIPanel/UICommon/WebViewObject.prefab");
            GameObject tempobj = loader.ResultObject as GameObject;
            GameObject insobj = GameObject.Instantiate(tempobj);
            webViewObj = insobj.GetComponent<NWebViewObject>();
            webViewObj.LoadWebByUrl(url);
            return true;
        }
        else
        {
            webViewObj.LoadWebByUrl(url);
        }
        #endif
        return false;
    }
    #endregion
}
