using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class NLuaEventRegister : MonoBehaviour
{
    public void RegisterEvent(List<EventDelegate> eventObject,
        LuaTable luaObject,
        LuaFunction luafunction)
    {
        EventDelegate.Add(eventObject, delegate()
        {
            if (luafunction != null)
            {
                luafunction.Call(luaObject);
            }
        });
    }

    static public NLuaEventRegister Get(GameObject go)
    {
        NLuaEventRegister LuaEvent = go.GetComponent<NLuaEventRegister>();
        if (LuaEvent == null) LuaEvent = go.AddComponent<NLuaEventRegister>();
        return LuaEvent;
    }
}
