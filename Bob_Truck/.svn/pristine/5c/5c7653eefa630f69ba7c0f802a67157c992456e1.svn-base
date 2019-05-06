using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLuaListViewWidget : NLuaUIWidgetBase
{
    public string m_mediatorName;               //该listview的mediator name
    public string m_notificationName;           //通知的名称
    public int m_itemsCount = 0;                //每个ListCell包含的ListItem数量，默认为0

    public int ItemsCount
    {
        get { return m_itemsCount; }
    }

    protected override void InitLuaAndAwake()
    {
        string luaPath = string.Format("Game/Module/{0}/{1}", m_modelPathName, LuaClassName);
        NManagerLua.Instance.LoadLuaClass(luaPath);
        m_handle = NManagerLua.Instance.InstantiateObject(LuaClassName);
        NManagerLua.Instance.CallObjectFunction(m_handle, "Awake", gameObject, m_mediatorName, m_notificationName);
    }

#if UNITY_EDITOR
    [Header("开发测试，真机没有后面两项参数")]
    public bool m_isDebug = false;
    public int m_dataCount = 10;
#endif

#if UNITY_EDITOR
    public virtual int DataCount()
    {
        if (m_isDebug)
        {
            return m_dataCount;
        }
        else
        {
            var rets = NManagerLua.Instance.CallObjectFunction(m_handle, "DataCount");
            return System.Convert.ToInt32(rets[0]);
        }
    }
#else
    public virtual int DataCount()
    {
        var rets = NManagerLua.Instance.CallObjectFunction(m_handle, "DataCount");
        return System.Convert.ToInt32(rets[0]);
    }
#endif
}
