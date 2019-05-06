﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Google.ProtocolBuffers;
using LuaInterface;
using System.Threading;
using System;
using System.Runtime.InteropServices;

public class NManagerNet : NSingleton<NManagerNet>
{
    protected NManagerNet() 
    {
        //_threadHeartBeat = new Thread(new ThreadStart(HeartBeatUpdate));
    }

    NRpcNetwork[] m_LoopNetInstList = new NRpcNetwork[8];//loop临时变量
    Dictionary<int, NRpcNetwork> m_dicRpcNetInst = new Dictionary<int, NRpcNetwork>();
    //         NetType         cmdid  Callback
    Dictionary<int, Dictionary<short, DelegateNetMsgHandler>> m_dicRespCallbks = new Dictionary<int, Dictionary<short, DelegateNetMsgHandler>>();
    //逻辑层的消息发送缓存
    Dictionary<int, List<NNetMsgDef>> m_quReqMsgList = new Dictionary<int, List<NNetMsgDef>>();

    //lua 消息处理函数名定义
    readonly string m_strLuaFunc_NetMsgProc = "LuaFunc_NetMsgProc";
    readonly string m_strLuaFuncNProcNetExcpt = "LuaFunc_NetExcptProc";
    readonly string m_strLuaFuncNProcNetMock = "LuaFunc_NetMockProc";
#if UNITY_EDITOR
    [NoToLua]
    public bool m_bMockMode = false; //消息模拟方式，客户端的请求直接在客户端本地模拟回复
#endif

    #region 逻辑层消息队列缓存
    //缓存一个发送请求
    bool CatchNetRequest(int nNetType, NNetMsgDef msg)
    {
        if (null == msg)
            return false;
        if (!m_quReqMsgList.ContainsKey(nNetType))
            m_quReqMsgList.Add(nNetType, new List<NNetMsgDef>());
        m_quReqMsgList[nNetType].Add(msg);
        return true;
    }
    
    public void ClearNetMsgCatch(int nNetType)
    {
        if (m_quReqMsgList.Count < 1)
            return;
        if (!m_quReqMsgList.ContainsKey(nNetType))
            return;
        m_quReqMsgList[nNetType].Clear();
        NRpcNetwork inst = GetRpcNet(nNetType);
        if (null != inst)
            inst.DropSumitList();
    }

    //尝试向RpcNet提交缓存队列
    bool TrySubmitRequstCatch(int nNetType)
    {
        NRpcNetwork inst = GetRpcNet(nNetType);
        if (null == inst)
        {
            NDebug.LogWarn("SubmitNetMsg Error1, Rpc inst is null");
            return false;
        }
        if (!m_quReqMsgList.ContainsKey(nNetType))
            return false;
        if (m_quReqMsgList[nNetType].Count < 1)
            return false;
        if (inst.BatchSend(m_quReqMsgList[nNetType]))
            m_quReqMsgList[nNetType].Clear();//提交成功，清空
        return true;
    }
    #endregion 逻辑层消息队列缓存

    //创建Rpc实例，逻辑层的请求都根据NetType进行
    public bool CreateRpcNet(int nNetType)
    {
        if (null != GetRpcNet(nNetType))
            return false;
        NRpcNetwork net = new NRpcNetwork(nNetType, OnRcvNetRespones, OnRcvNetException);
        m_dicRpcNetInst.Add(nNetType, net);
        return true;
    }

    // 发起连接
    public bool StartRpcConnect(int nNetType, string strHost, int nPort)
    {
        NRpcNetwork inst = GetRpcNet(nNetType);
        if (null == inst)
        {
            CreateRpcNet(nNetType);
            inst = GetRpcNet(nNetType);
        }
        if (null == inst)
            return false;
        inst.DoConnect(strHost, nPort);
        return true;
    }

    #region 逻辑层发消息接口
    [NoToLua]
    public void SendNetMsg(int nNetType, short sCmdID, byte[] bts)
    {
        NRpcNetwork inst = GetRpcNet(nNetType);
        if (null == inst)
        {
            NDebug.LogWarn("SendNetMsg Error1, Rpc inst is null");
            return;
        }
        //Mock处理
        NNetMsgDef stMsg = NNetMsgDef.Create(sCmdID, bts);
#if UNITY_EDITOR
        if (!m_bMockMode || !ProcMock(nNetType, stMsg))
        {
            CatchNetRequest(nNetType, stMsg);
        }
#else
         CatchNetRequest(nNetType, stMsg);
#endif
    }
    //Lua内用这个接口
    public void SendLuaNetMsg(int nNetType, short sCmdID, LuaByteBuffer msg)
    {
        SendNetMsg(nNetType, sCmdID, msg.buffer);
    }
    #endregion
    NRpcNetwork GetRpcNet(int nNetType)
    {
        if (!m_dicRpcNetInst.ContainsKey(nNetType))
            return null;
        return m_dicRpcNetInst[nNetType];
    }
    #region Resp处理逻辑
    void AddRespCallbk(int nNetType, short sCmdID, DelegateNetMsgHandler callbk)
    {
        if (null == callbk)
            return;
        if (!m_dicRespCallbks.ContainsKey(nNetType))
        {
            m_dicRespCallbks.Add(nNetType, new Dictionary<short, DelegateNetMsgHandler>());
        }
        if (!m_dicRespCallbks[nNetType].ContainsKey(sCmdID))
        {
            m_dicRespCallbks[nNetType].Add(sCmdID, callbk);
        }
    }
    void RmvRespCallbk(int nNetType, short sCmdID)
    {
        if (m_dicRespCallbks.ContainsKey(nNetType) && m_dicRespCallbks[nNetType].ContainsKey(sCmdID))
        {
            m_dicRespCallbks[nNetType].Remove(sCmdID);
        }
    }
    bool DispatchRespCallbk(int nNetType, NNetMsgDef stMsg)
    {
        if (null == stMsg || null == stMsg.stHeader)
            return true;
        try
        {
            if (m_dicRespCallbks.ContainsKey(nNetType))
            {
                short sCmdID = stMsg.stHeader.sCmdID;
                if (m_dicRespCallbks[nNetType].ContainsKey(sCmdID))
                {
                    m_dicRespCallbks[nNetType][sCmdID](stMsg);
                    return true;
                }
            }
        }
        catch (Exception e)
        {
            NDebug.LogWarn(string.Format("DispatchRespCallbk Excpt:" + e.Message));
        }
        return false;
    }
    //Respones回调处理入口，在这层进行分发
    void OnRcvNetRespones(int nNetType, NNetMsgDef stMsg)
    {
        if (null == stMsg || null == stMsg.stHeader)
            return;
        try
        {
            if (!DispatchRespCallbk(nNetType, stMsg))
            {
                short sCmdID = stMsg.stHeader.sCmdID;
                //交给Lua处理,lua内根据cmd id建立callbk索引关系
                if (null != stMsg.btsData)
                {
                    LuaByteBuffer luaStringBuf = new LuaByteBuffer(stMsg.btsData);
                    NManagerLua.Instance.CallFunction(m_strLuaFunc_NetMsgProc, new object[] { nNetType, sCmdID, luaStringBuf });
                }
                else
                {
                    NManagerLua.Instance.CallFunction(m_strLuaFunc_NetMsgProc, new object[] { nNetType, sCmdID });
                }
            }
        }
        catch (Exception e)
        {
            NDebug.LogWarn(string.Format("DispatchRespCallbk Excpt:" + e.Message));
        }
    }
    #endregion

    #region exception 处理逻辑
    //Except 回调处理入口，在这层进行分发
    void OnRcvNetException(int nNetType, NNetExpType e)
    {
        //给lua处理
        NManagerLua.Instance.CallFunction(m_strLuaFuncNProcNetExcpt, new object[] { nNetType, (int)e });
    }
    #endregion

    //关闭所有网络
    public void CloseAll()
    {
        ushort usNetInstCount = GetNetRpcLoopList();
        for (ushort i = 0; i < usNetInstCount; ++i)
        {
            if (null == m_LoopNetInstList[i])
                continue;
            ClearNetMsgCatch(m_LoopNetInstList[i].TypeID);
            if (m_LoopNetInstList[i].IsConnect())
                m_LoopNetInstList[i].OnDisconnected("NManagerNet Close All!");
        }
    }
    //网络连接状态
    public bool IsConnect(int nNetType)
    {
        var rpc = GetRpcNet(nNetType);
        if (null == rpc)
            return false;
        return rpc.IsConnect();
    }
    //关闭网络
    public void Close(int nNetType)
    {
        var rpc = GetRpcNet(nNetType);
        if (rpc != null)
        {
            rpc.OnDisconnected(string.Format("NManagerNet Close ENetType = {0}", nNetType.ToString()));
        }
    }
    public override void Release()
    {
        CloseAll();
        m_dicRpcNetInst.Clear();
        Array.Clear(m_LoopNetInstList, 0, m_LoopNetInstList.Length);

        if (_threadHeartBeat != null)
        {
            _threadHeartBeat.Abort();
            _threadHeartBeat = null;
            _isBackGround = false;
        }
    }
    
    #region 多线程发心跳包
    private Thread _threadHeartBeat = null;
    private bool _isBackGround = false;
    void HeartBeatUpdate()
    {
        while (true)
        {
            if (!_isBackGround)
            {
                ushort usNetInstCount = GetNetRpcLoopList();
                for (ushort i = 0; i < usNetInstCount; ++i)
                {
                    if (null != m_LoopNetInstList[i])
                        m_LoopNetInstList[i].RequestHeartBeat();
                }
            }
            Thread.Sleep(2500);
        }
    }

    void ApplicationPause(bool paused)
    {
        _isBackGround = paused;
    }
    #endregion

    
    void Update()
    {
        ushort usNetInstCount = GetNetRpcLoopList();
        for (ushort i = 0; i < usNetInstCount; ++i)
        {
            if (null != m_LoopNetInstList[i])
            {
                TrySubmitRequstCatch(m_LoopNetInstList[i].TypeID);
                m_LoopNetInstList[i].Update(Time.deltaTime);
            }
        }
#if UNITY_EDITOR
        if (Input.GetKeyDown(KeyCode.K))
        {
            //for (byte i = 0; i < 10; ++i)
            //    SendLuaNetMsg(1, 1, new LuaByteBuffer(new byte[] { 1, 2, 3 }));
        }
#endif
    }

    ushort GetNetRpcLoopList()
    {
        if (m_dicRpcNetInst.Count < 1)
            return 0;
        ushort usCount = 0;
        if (m_LoopNetInstList.Length < m_dicRpcNetInst.Count)
            m_LoopNetInstList = new NRpcNetwork[m_dicRpcNetInst.Count];
        foreach (var v in m_dicRpcNetInst)
        {
            if (null != v.Value)
                m_LoopNetInstList[usCount++] = v.Value;
        }
        return usCount;
    }


    #region Mock处理
    #if UNITY_EDITOR
    bool ProcMock(int nNetType, NNetMsgDef stMsg)
    {
        if (null == stMsg || null == stMsg.stHeader)
            return false;
        try
        {
            object[] aryRets = null;
            if (null != stMsg.btsData)
            {
                LuaByteBuffer luaBts = new LuaByteBuffer(stMsg.btsData);
                aryRets = NManagerLua.Instance.CallFunction(m_strLuaFuncNProcNetMock, new object[] { nNetType, stMsg.stHeader.sCmdID, luaBts });
            }
            else
                aryRets = NManagerLua.Instance.CallFunction(m_strLuaFuncNProcNetMock, new object[] { nNetType, stMsg.stHeader.sCmdID });

            if (null == aryRets || aryRets.Length < 1)//未被处理
                return false;

            //获取返回值
            bool bRet = aryRets[0] != null;
            return bRet;
        }
        catch (Exception e)
        {
            NDebug.LogWarn("ProcMock Exception:" + e.Message);
        }
        return false;
    }
    #endif

    public void LuaDirectAckNetMsg(int nNetType, short sCmdID, LuaByteBuffer msg)
    {
        OnRcvNetRespones(nNetType, NNetMsgDef.Create(sCmdID, msg.buffer));
    }
    #endregion
}