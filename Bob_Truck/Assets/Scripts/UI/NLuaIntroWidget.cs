using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLuaIntroWidget : NLuaUIWidgetBase
{
    public GameObject m_eventObject;            //需要引导的对象
    public int m_introPoint;                       //引导事件ID

    protected override void InitLuaAndAwake()
    {
        string luaPath = string.Format("Game/Module/{0}/{1}", m_modelPathName, LuaClassName);
        NManagerLua.Instance.LoadLuaClass(luaPath);
        m_handle = NManagerLua.Instance.InstantiateObject(LuaClassName);
        NManagerLua.Instance.CallObjectFunction(m_handle, "Awake", m_eventObject, m_introPoint);
    }
}
