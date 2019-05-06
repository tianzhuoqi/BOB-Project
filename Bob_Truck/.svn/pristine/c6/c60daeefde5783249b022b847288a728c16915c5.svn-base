using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

#pragma warning disable 0108

public class NLuaUIPanelBase : NUIPanelBase 
{
    //所在模块的名字
    [NoToLua]
    public string m_modelPathName;

    private int m_handle;

    [NoToLua]
    public string LuaClassName;

    protected void Awake()
    {
        InitLuaAndAwake();
        base.Awake();
    }

    protected void InitLuaAndAwake()
    {
        try
        {
            string luaPath = string.Format("Game/Module/{0}/{1}", m_modelPathName, LuaClassName);
            NManagerLua.Instance.LoadLuaClass(luaPath);
            m_handle = NManagerLua.Instance.InstantiateObject(LuaClassName);
            NManagerLua.Instance.CallObjectFunction(m_handle, "Awake", gameObject);
        }
        catch (System.Exception e)
        {
            NDebug.LogError(string.Format("{0} InitLuaAndAwake Catch exception {1}", LuaClassName, e.Message));
        }
    }


    [NoToLua]
    public override void OpenPanel()
    {
        base.OpenPanel();
        NManagerLua.Instance.CallObjectFunction(m_handle, "OpenPanel");
    }

    [NoToLua]
    public override void ClosePanel()
    {
        base.ClosePanel();
        NManagerLua.Instance.CallObjectFunction(m_handle, "ClosePanel");
    }

    [NoToLua]
    public override void ReopenPanel()
    {
        base.ReopenPanel();
        NManagerLua.Instance.CallObjectFunction(m_handle, "ReopenPanel");
    }

    [NoToLua]
    public override void DestroyPanel()
    {
        base.DestroyPanel();
        NManagerLua.Instance.CallObjectFunction(m_handle, "DestroyPanel");
    }
}
