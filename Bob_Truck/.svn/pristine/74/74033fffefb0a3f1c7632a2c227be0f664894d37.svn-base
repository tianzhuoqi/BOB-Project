using UnityEngine;
using System.Collections;
using LuaInterface;
using System.Collections.Generic;
using System.IO;
using System;

public class NManagerLua : NSingleton<NManagerLua>
{
    protected NManagerLua()
    {
    }

    private LuaState lua;
    private LuaLooper loop;

    private NLuaLoader loader;

    private Dictionary<string, string> m_pBundlePathDic = new Dictionary<string, string>();

    void Awake() 
    {
        lua = new LuaState();
        loader = new NLuaLoader();
        OpenLibs();
        lua.LuaSetTop(0);

        //注册WARP
        LuaBinder.Bind(lua);

        DelegateFactory.Init();

        //注册unity版本的协同
        LuaCoroutine.Register(lua, this);
    }

    [NoToLua]
    public override void Release()
    {
        if (loop != null)
        {
            loop.Destroy();
            loop = null;
        }
        if (lua != null)
        {
            lua.Dispose();
            lua = null;
        }

        if (loader != null)
            loader = null;
    }

    public void LoadBundle(string luaName)
    {
        var load = NManagerResourceModule.LoadBundle(luaName + ".unity3d") as NAssetFileLoader;

        LuaFileUtils.Instance.AddSearchBundle(luaName, load.BundleLoader.Bundle);
    }

    public void InitStart() 
    {
        //初始化加载位置
        InitLuaPath();

        //启动LUAVM
        lua.Start();

        //读取MAIN入口
        StartMain();

        //启动lua的周期函数
        StartLooper();
    }

    /// <summary>
    /// 初始化加载第三方库
    /// </summary>
    void OpenLibs() 
    {
        lua.OpenLibs(LuaDLL.luaopen_pb);
        lua.OpenLibs(LuaDLL.luaopen_struct);
        lua.OpenLibs(LuaDLL.luaopen_lpeg);

#if UNITY_STANDALONE_OSX || UNITY_EDITOR_OSX
        lua.OpenLibs(LuaDLL.luaopen_bit);
#endif

        if (LuaConst.openLuaVSCodeDebugger)
        {
            OpenLuaSocket();
        }
    }

    /// <summary>
    /// 初始化Lua代码加载路径
    /// </summary>
    void InitLuaPath()
    {
        //默认路径LuaConst.luaDir  LuaConst.toluaDir
        lua.AddSearchPath(NConst.DataPath + "Lua");
        lua.AddSearchPath(LuaConst.toluaDir);
    }

    void StartMain()
    {
        lua.DoFile("Main.lua");
        LuaFunction main = lua.GetFunction("Main");
        main.Call();
        main.Dispose();
        main = null;
    }

    void StartLooper()
    {
        loop = gameObject.AddComponent<LuaLooper>();
        loop.luaState = lua;
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int LuaOpen_Socket_Core(IntPtr L)
    {
        return LuaDLL.luaopen_socket_core(L);
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int LuaOpen_Mime_Core(IntPtr L)
    {
        return LuaDLL.luaopen_mime_core(L);
    }

    protected void OpenLuaSocket()
    {
        lua.BeginPreLoad();
        lua.RegFunction("socket.core", LuaOpen_Socket_Core);
        lua.RegFunction("mime.core", LuaOpen_Mime_Core);
        lua.EndPreLoad();
    }

    // 调用Lua脚本
    public void DoFile(string filename) 
    {
        lua.DoFile(filename);
    }

    public int InstantiateObject(string className, params object[] args)
    {
        object[] wrap = new object[args.Length + 2];
        wrap[0] = className;
        for (int i = 0; i < args.Length; i++)
        {
            wrap[1 + i] = args[i];
        }
        object[] result = CallFunction("InstantiateObject", wrap);
        if (result.Length <= 0) return 0;
        return System.Convert.ToInt32(result[0]);
    }

    public object[] CallObjectFunction(int handle, string funcName, params object[] args)
    {
        //必须二次封装一下，否则lua收到的是System.Object[]
        object[] wrap = new object[args.Length + 2];
        wrap[0] = handle;
        wrap[1] = funcName;
        for (int i = 0; i < args.Length; i++)
        {
            wrap[2 + i] = args[i];
        }
        return CallFunction("CallObjectFunction", wrap);
    }

    // 调用LUA全局函数
    public object[] CallFunction(string funcName, params object[] args)
    {
        LuaFunction func = lua.GetFunction(funcName);
        if (func != null)
        {
            //LazyCall存在GC问题,所有用下面这种方式来做
            //这个地方未来还可能根据不同的情况来写
            return func.LazyCall(args);
        }
        return null;
    }

    public object[] CallFunctionInvoke(string funcName, params object[] args) 
    {
        LuaFunction func = lua.GetFunction(funcName);
        if (func != null) 
        {
            if (args.Length == 0)
                return func.Invoke<object[]>();
            else if (args.Length == 1)
                return func.Invoke<object, object[]>(args[0]);
            else if (args.Length == 2)
                return func.Invoke<object, object, object[]>(args[0], args[1]);
            else if (args.Length == 3)
                return func.Invoke<object, object, object, object[]>(args[0], args[1], args[2]);
            else if (args.Length == 4)
                return func.Invoke<object, object, object, object, object[]>(args[0], args[1], args[2], args[3]);
            else if (args.Length == 5)
                return func.Invoke<object, object, object, object, object, object[]>(args[0], args[1], args[2], args[3], args[4]);
            else if (args.Length == 6)
                return func.Invoke<object, object, object, object, object, object, object[]>(args[0], args[1], args[2], args[3], args[4], args[5]);
            else if (args.Length == 7)
                return func.Invoke<object, object, object, object, object, object, object, object[]>(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
            else if (args.Length == 8)
                return func.Invoke<object, object, object, object, object, object, object, object, object[]>(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
            else if (args.Length == 9)
                return func.Invoke<object, object, object, object, object, object, object, object, object, object[]>(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
        }
        NDebug.LogError("NManagerLua.CallFunction Error! funcName = " + funcName + " args.length = " + args.Length);
        return null;
    }

    // 清理
    public void LuaGC()
    {
        lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
    }

    // 加载lua的文件,刻意这么做的原因是只希望一个地方使用Dofile,其他地方都使用require
    public void LoadLuaClass(string path)
    {
        CallFunction("LoadClass", path);
    }

    // 是否是特殊语种国家
    private bool m_IsRTL = false;
    public void SetLangugeRTL(bool isRTL)
    {
        m_IsRTL = isRTL;
    }
}