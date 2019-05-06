﻿using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLuaUIWidgetBase : NUIWidgetBase
{
    //所在模块的名字
    [NoToLua]
    public string m_modelPathName;

    protected int m_handle;

    [NoToLua]
    public string LuaClassName;

    protected override void Awake()
    {
        InitLuaAndAwake();
        base.Awake();
    }

    protected virtual void InitLuaAndAwake()
    {
        string luaPath = string.Format("Game/Module/{0}/{1}", m_modelPathName, LuaClassName);
        NManagerLua.Instance.LoadLuaClass(luaPath);
        m_handle = NManagerLua.Instance.InstantiateObject(LuaClassName);
        NManagerLua.Instance.CallObjectFunction(m_handle, "Awake", gameObject);
    }

    protected override void OnClick()
    {
        base.OnClick();
        NManagerLua.Instance.CallObjectFunction(m_handle, "OnClick");
    }

    private float _longClickDuration = 1f;
    float _lastPress = -1f;

    protected override void OnPress(bool pressed)
    {
        base.OnPress(pressed);
        NManagerLua.Instance.CallObjectFunction(m_handle, "OnPress", pressed);

        if (pressed)
        {
            _lastPress = Time.realtimeSinceStartup;
        }
        else
        {
            if (Time.realtimeSinceStartup - _lastPress >= _longClickDuration)
            {
                NManagerLua.Instance.CallObjectFunction(m_handle, "OnLongPress");
            }
        }

    }

    protected override void OnDrag(Vector2 delta)
    {
        base.OnDrag(delta);
        NManagerLua.Instance.CallObjectFunction(m_handle, "OnDrag", delta);
    }

    protected override void OnScroll(float delta)
    {
        base.OnScroll(delta);
        NManagerLua.Instance.CallObjectFunction(m_handle, "OnScroll", delta);
    }

    public void OnDropUp(int index, string notificationKey)
    {
        NManagerLua.Instance.CallObjectFunction(m_handle, "OnDropUp", index, notificationKey);
    }

	void OnDestroy()
	{
		NManagerLua.Instance.CallObjectFunction(m_handle, "OnDestroy");
	}
}
