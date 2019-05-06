using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLuaTabViewWidget : NLuaUIWidgetBase
{
    public string m_mediatorName;               //该tabview的mediator name

    protected override void InitLuaAndAwake()
    {
        string luaPath = string.Format("Game/Module/{0}/{1}", m_modelPathName, LuaClassName);
        NManagerLua.Instance.LoadLuaClass(luaPath);
        m_handle = NManagerLua.Instance.InstantiateObject(LuaClassName);
        NManagerLua.Instance.CallObjectFunction(m_handle, "Awake", gameObject, m_mediatorName);
    }
}
