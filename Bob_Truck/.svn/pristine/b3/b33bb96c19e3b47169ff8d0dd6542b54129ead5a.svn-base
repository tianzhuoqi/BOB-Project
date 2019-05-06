using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLuaTabItemWidget : NLuaUIWidgetBase
{
    public string m_notificationName;           //通知的名称

    public void Init(int index)
    {
        NManagerLua.Instance.CallObjectFunction(m_handle, "Init", index, m_notificationName);
    }
}
