using UnityEngine;
using System;
using System.Collections.Generic;
using System.Collections;
using LuaInterface;

[RequireComponent(typeof(UIEventListener))]
public class NLuaClickEvent : MonoBehaviour
{
    /// <summary>
    /// 处理C#回调LUA的接口，点击按钮时候C#会直接处理注册好的luafunction
    /// 此函数和RegisterCallback是互斥的，不要同时使用
    /// </summary>
    bool is3D = false;
    bool mouseDown = false;
    Vector3 lastClick = Vector3.zero;
    Camera camera = null;
    bool isOverUI = false;
    bool isPressed = false;
    bool isCheckingLongPress = false;
    float timer = 0;
    float longPressDeltaTime = 0;
    float longPressStartTime = 0.5f;
    bool longPressTrigger = false;

    Dictionary<string, LuaFunction> m_LuaFunctionDic = new Dictionary<string, LuaFunction>();
    Dictionary<string, LuaTable> m_LuaTableDic = new Dictionary<string, LuaTable>();

    public void AddClick(LuaTable lobject, LuaFunction function, LuaTable data)
    {
        if (!m_LuaFunctionDic.ContainsKey("Click"))
            m_LuaFunctionDic.Add("Click", function);
        else
            m_LuaFunctionDic["Click"] = function;

        if (!m_LuaTableDic.ContainsKey("Click"))
            m_LuaTableDic.Add("Click", lobject);
        else
            m_LuaTableDic["Click"] = lobject;

        UIEventListener.Get(gameObject).onClick = delegate
        {
            if (m_LuaFunctionDic.ContainsKey("Click") && m_LuaFunctionDic["Click"] != null)
            {
                m_LuaFunctionDic["Click"].Call(m_LuaTableDic["Click"], data);
            }
        };
    }

    public void AddClick(LuaTable lobject, LuaFunction function)
    {
        if (!m_LuaFunctionDic.ContainsKey("Click"))
            m_LuaFunctionDic.Add("Click", function);
        else
            m_LuaFunctionDic["Click"] = function;

        if (!m_LuaTableDic.ContainsKey("Click"))
            m_LuaTableDic.Add("Click", lobject);
        else
            m_LuaTableDic["Click"] = lobject;

        UIEventListener.Get(gameObject).onClick = delegate
        {
            if (m_LuaFunctionDic.ContainsKey("Click") && m_LuaFunctionDic["Click"] != null)
            {
                m_LuaFunctionDic["Click"].Call(m_LuaTableDic["Click"]);
            }
        };
    }

    public void Add3DClick(LuaTable lobject, LuaFunction function)
    {
        Add3DClick(lobject, function, Camera.main);
    }

    public void Add3DClick(LuaTable lobject, LuaFunction function, Camera camera)
    {
        this.camera = camera;

        if (null == this.camera)
        {
            this.camera = Camera.main;
        }

        if (!m_LuaFunctionDic.ContainsKey("Click"))
            m_LuaFunctionDic.Add("Click", function);
        else
            m_LuaFunctionDic["Click"] = function;

        if (!m_LuaTableDic.ContainsKey("Click"))
            m_LuaTableDic.Add("Click", lobject);
        else
            m_LuaTableDic["Click"] = lobject;

        is3D = true;
    }

    public void AddPress(LuaTable lobject, LuaFunction function)
    {
        if (!m_LuaFunctionDic.ContainsKey("Press"))
            m_LuaFunctionDic.Add("Press", function);
        else
            m_LuaFunctionDic["Press"] = function;

        if (!m_LuaTableDic.ContainsKey("Press"))
            m_LuaTableDic.Add("Press", lobject);
        else
            m_LuaTableDic["Press"] = lobject;

        UIEventListener.Get(gameObject).onPress += delegate(GameObject go, bool isPress)
        {
            if (m_LuaFunctionDic.ContainsKey("Press") && m_LuaFunctionDic["Press"] != null)
            {
                m_LuaFunctionDic["Press"].Call(m_LuaTableDic["Press"], isPress);
            }
        };
    }

    public void Add3DPress(LuaTable lobject, LuaFunction function)
    {
        Add3DPress(lobject, function, Camera.main);
    }

    public void Add3DPress(LuaTable lobject, LuaFunction function, Camera camera)
    {
        this.camera = camera;

        if (null == this.camera)
        {
            this.camera = Camera.main;
        }

        if (!m_LuaFunctionDic.ContainsKey("Press"))
            m_LuaFunctionDic.Add("Press", function);
        else
            m_LuaFunctionDic["Press"] = function;

        if (!m_LuaTableDic.ContainsKey("Press"))
            m_LuaTableDic.Add("Press", lobject);
        else
            m_LuaTableDic["Press"] = lobject;

        is3D = true;
    }

    //添加长按时间，deltaTime为触发间隔
    public void AddLongPress(LuaTable lobject, LuaFunction function, float deltaTime)
    {
        if (!m_LuaFunctionDic.ContainsKey("LongPress"))
            m_LuaFunctionDic.Add("LongPress", function);
        else
            m_LuaFunctionDic["LongPress"] = function;

        if (!m_LuaTableDic.ContainsKey("LongPress"))
            m_LuaTableDic.Add("LongPress", lobject);
        else
            m_LuaTableDic["LongPress"] = lobject;

        UIEventListener.Get(gameObject).onPress += delegate (GameObject go, bool isPress)
        {
            this.isPressed = isPress;
        };

        longPressDeltaTime = deltaTime;
        isCheckingLongPress = true;
    }


    void OnDestroy()
    {
        if (m_LuaFunctionDic != null)
            m_LuaFunctionDic.Clear();
        if (m_LuaTableDic != null)
            m_LuaTableDic.Clear();
    }

    void Update()
    {
        if (is3D)
        {
            if (camera == Camera.main)
            {
                isOverUI = UICamera.isOverUI;
            }

            if (Input.GetMouseButtonDown(0) && !mouseDown && !isOverUI)
            {
                mouseDown = true;
                lastClick = Input.mousePosition;
                Ray ray = camera.ScreenPointToRay(Input.mousePosition);
                RaycastHit hit;
                if (Physics.Raycast(ray, out hit))
                {
                    if (hit.collider.gameObject == gameObject)
                    {
                        if (m_LuaFunctionDic.ContainsKey("Press") && m_LuaFunctionDic["Press"] != null)
                        {
                            m_LuaFunctionDic["Press"].Call(m_LuaTableDic["Press"], true);
                        }
                    }
                }
            }

            if (Input.GetMouseButtonUp(0) && mouseDown && !isOverUI)
            {
                if ((lastClick - Input.mousePosition).magnitude < 10)
                {
                    Ray ray = camera.ScreenPointToRay(Input.mousePosition);
                    RaycastHit hit;
                    if (Physics.Raycast(ray, out hit))
                    {
                        if (hit.collider.gameObject == gameObject)
                        {
                            if (m_LuaFunctionDic.ContainsKey("Click") && m_LuaFunctionDic["Click"] != null)
                            {
                                m_LuaFunctionDic["Click"].Call(m_LuaTableDic["Click"]);
                            }
                        }
                    }
                }

                if (m_LuaFunctionDic.ContainsKey("Press") && m_LuaFunctionDic["Press"] != null)
                {
                    m_LuaFunctionDic["Press"].Call(m_LuaTableDic["Press"], false);
                }

                mouseDown = false;
            }
        }

        if (isCheckingLongPress)
        {
            if (isPressed)
            {
                timer += Time.deltaTime;
                if (longPressTrigger == true)
                {
                    if (timer >= longPressDeltaTime)
                    {
                        timer = 0;
                        if (m_LuaFunctionDic.ContainsKey("LongPress") && m_LuaFunctionDic["LongPress"] != null)
                            m_LuaFunctionDic["LongPress"].Call(m_LuaTableDic["LongPress"]);
                    }
                }
                else
                {
                    if (timer >= longPressStartTime)
                    {
                        timer = 0;
                        longPressTrigger = true;
                    }
                }
                
            }
            else
            {
                timer = 0;
                longPressTrigger = false;
            }
        }
    }

    static public NLuaClickEvent Get(GameObject go)
    {
        NLuaClickEvent clickEvent = go.GetComponent<NLuaClickEvent>();
        if (clickEvent == null) clickEvent = go.AddComponent<NLuaClickEvent>();
        return clickEvent;
    }
}