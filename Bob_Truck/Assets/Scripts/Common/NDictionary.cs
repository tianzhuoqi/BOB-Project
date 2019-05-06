using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

/// <summary>
/// 封装Dictionary,原版的问题在于编码书写太长
/// 不利于看问题,同时导出成LUA也不方便
/// </summary>
public class NDictionary
{
	private Dictionary<object, object> m_data = new Dictionary<object, object>();

    public void Push(object key, Int32 value)
    {
        if (!m_data.ContainsKey(key))
            m_data.Add(key, value);
        else
        {
            NDebug.LogError("PushInt32 NDictionary Key : {0}; Value : {1} Error", key, value);
            m_data[key] = value;
        }
    }

    public void Push(object key, double value)
    {
        if (!m_data.ContainsKey(key))
            m_data.Add(key, value);
        else
        {
            NDebug.LogError("PushDouble NDictionary Key : {0}; Value : {1} Error", key, value);
            m_data[key] = value;
        }
    }

	public void Push(object key, object value)
	{
        if (!m_data.ContainsKey(key))
            m_data.Add(key, value);
        else
        {
            NDebug.LogError("Push NDictionary Key : {0}; Value : {1} Error", key, value);
            m_data[key] = value;
        }
	}
	
	public void ChangeValue(object key, object value)
	{
		if (m_data.ContainsKey(key))
			m_data[key] = value;
		else
            NDebug.LogError("NIntent ChangeValue() Error! Key = {0}", key);
	}
	
	public bool Remove(object key)
	{
		return m_data.Remove(key);
	}

    public object Value(object key)
    {
        return Value<object>(key);
    }

    [NoToLua]
	public T Value<T>(object key)
	{
		if (m_data.ContainsKey(key))
		{
			T res = (T)m_data[key];
			return res;
		}
		else
		{
			return default(T);
		}
	}
	
	public bool HaveKey(object key)
	{
		return m_data.ContainsKey(key);
	}
	
	public bool HaveValue(object value)
	{
		return m_data.ContainsValue(value);
	}
	
	public void Clear()
	{
		m_data.Clear();
	}

    public int Count()
    {
        return m_data.Count;
    }

    public static NDictionary New()
    {
        return new NDictionary();
    }
}
