using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.SceneManagement;

public class NLuaUIPanelContainerBase : MonoBehaviour 
{
    [NoToLua]
    public NUIPanelContainerBase m_containerBase;

    void Awake()
    {
        string openFuntion = string.Format("PanelRegister.{0}", SceneManager.GetActiveScene().name);
        NManagerLua.Instance.CallFunction(openFuntion, m_containerBase);
    }
}