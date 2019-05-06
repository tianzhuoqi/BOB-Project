using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Net;
using System.IO;
using System.Text;
using Google.ProtocolBuffers;
using LuaInterface;

using System.Security.Cryptography;
using UnityEngine;


public class NRpcNetwork
{
    int m_nTypeID = 0; //类型标识
    public int TypeID { get { return m_nTypeID; } }
    private TcpClient _tcpclient = null;
    private NetworkStream outStream = null;
    NMemeryStream m_stSendFmtBuffer = new NMemeryStream(1024 * 16);//组装发送数据的缓冲
    //14K
    private const int MAX_READ = 14 * 1024;
    private byte[] byteBuffer = new byte[MAX_READ];
    NMemeryStream m_stRecvBuffer = new NMemeryStream(1024 * 128);//socket层的字节接受缓存区

    Queue<NNetMsgDef> m_quRequestMsgs = new Queue<NNetMsgDef>(); //协议层发送消息包缓存区，主线程与子线程共享
    Queue<NNetMsgDef> m_quResponseMsgs = new Queue<NNetMsgDef>(); //协议层接收消息包缓存区，主线程与子线程共享
    List<NNetMsgDef> m_lstNowSubmitMsgs = new List<NNetMsgDef>(); //当前已经向m_quRequestMsgs提交的消息列表，发送超时时，重发的也是这个队列
                                                           //当这个列表里有消息需要等待resp时，等收到resp时清空，不需要resp时，直接清空
    //回调
    DelegateRPCExceptHandler m_callbkExcpt = null; //exception
    DelegateResponseRPCHandler m_callbkResponese = null;//resp

    //------------------------------下面3个变量在断开后不重置//------------------------------
    List<NNetExpType> _listExceptions = new List<NNetExpType>(); //异常信息 主线程与子线程共享
    NNetExpType[] m_ExpceptLoopList = new NNetExpType[16];
    List<string> _listLogs = new List<string>(); //日志信息 主线程与子线程共享

    private bool IsConnectionSuccessful = false;    //是否曾建立连接成功
    private bool IsLoseConnected = true;            //连接成功后，用此属性判断当前连接是否存在
    private bool IsBeginConnect = false;
    //private Thread m_threadBeginConnect;
    byte[] m_btsHeartBeatContent = null;//心跳包内容

    //发送超时在这层处理
    const double c_dSendTimeoutLength = 8.0; //发送超时时间 s
    double m_dTraceTimeout = 0.0;
    [NoToLua]
    public NRpcNetwork(int nType, DelegateResponseRPCHandler resp, DelegateRPCExceptHandler except)
    {
        m_nTypeID = nType;
        m_callbkResponese = resp;
        m_callbkExcpt = except;
    }


    #region 连接TCP相关
    [NoToLua]
    public void DoConnect(string host, int port)
    {
        if (IsBeginConnect)
            return;
        IsConnectionSuccessful = false;
        IPAddress[] addr = Dns.GetHostAddresses(host);
        if (addr.Length == 0)
        {
            OnExceptions(NNetExpType.OnConnectFailed);
            return;
        }
        _tcpclient = new TcpClient(addr[0].AddressFamily);

        try
        {
            OnLog("SendConnect host = " + host + " port = " + port);
            //尝试连接
            //m_threadBeginConnect = new Thread(BeginConnectUpdate);
            //m_threadBeginConnect.Start();
            IsBeginConnect = true;
            _tcpclient.BeginConnect(addr[0], port, new AsyncCallback(OnConnected), null);
        }
        catch (Exception e)
        {
            string str = string.Format("<Net> SendConnect Error! {0}", e.Message);
            OnDisconnected(str);
            OnExceptions(NNetExpType.ConnectFailed);
        }
    }

    protected void OnConnected(IAsyncResult asr)
    {
        IsBeginConnect = false;

        if (_tcpclient != null && _tcpclient.Connected)
        {
            //连接成功后，结束挂起的异步连接尝试
            _tcpclient.EndConnect(asr);
            OnLog("OnConnected Finish");
            //提交发送请求
            Submit2NetCatch();

            IsConnectionSuccessful = true;
            outStream = _tcpclient.GetStream();
            outStream.BeginRead(byteBuffer, 0, MAX_READ, new AsyncCallback(OnRead), null);
            OnExceptions(NNetExpType.OnConnectSucceed);
        }
        else
        {
            string str = "<Net> OnConnectFailed! _tcpclient is null or !_tcpclient.Connected";
            OnDisconnected(str);
            OnExceptions(NNetExpType.OnConnectFailed);
        }
    }

    [NoToLua]
    public void OnDisconnected(string msg)
    {
        m_stRecvBuffer.Reset();
        if (outStream != null)
        {
            outStream.Dispose();
            outStream.Close();
        }

        if (_tcpclient != null)
            _tcpclient.Close();
        _tcpclient = null;

        //_responseCallBack.Clear();
        m_quResponseMsgs.Clear();
        m_quRequestMsgs.Clear();
        //m_lstNowSubmitMsgs.Clear();

        Array.Clear(byteBuffer, 0, byteBuffer.Length);

        //IsConnectionSuccessful = false;
        IsLoseConnected = false;
        m_btsHeartBeatContent = null;
        OnLog(msg);
    }
    #endregion

    public void DropSumitList()
    {
        m_lstNowSubmitMsgs.Clear();
        if (m_dTraceTimeout > 0.0)
        {
            m_dTraceTimeout = 0;
            OnExceptions(NNetExpType.StopWait);
        }
    }

    #region 发送RPC相关
    
    public bool BatchSend(List<NNetMsgDef> lst)
    {
        if (m_lstNowSubmitMsgs.Count > 0)
            return false;//正在提交
        
        foreach (var v in lst)
        {
            m_lstNowSubmitMsgs.Add(v);
        }
        Submit2NetCatch();
        return true;
    }

    //提交到发送队列
    bool Submit2NetCatch()
    {
        bool bWaitResp = false;
        do
        {
            if (m_lstNowSubmitMsgs.Count < 1)
                break;
            
            lock (m_quRequestMsgs)
            {
                foreach (var v in m_lstNowSubmitMsgs)
                {
                    if (v.GetRespCmdID() > 0)
                        bWaitResp = true;
                    m_quRequestMsgs.Enqueue(v);
                    OnLog(string.Format("SendData Cmd<{0}>", v.stHeader.sCmdID));
                }
            }
        } while (false);
        if (bWaitResp)//启动等待resp
        {
            m_dTraceTimeout = c_dSendTimeoutLength;
            OnExceptions(NNetExpType.StartWait);
        }
        else
            m_lstNowSubmitMsgs.Clear();
        return bWaitResp;
    }
    
    /// <summary>
    /// 发送HEARTBEAT
    /// </summary>
    /// <param name="requestname"></param>
    public void RequestHeartBeat()
    {//!!注意这个调用可能来自另外的线程
        if (_tcpclient == null || !_tcpclient.Connected)
        {
            return;
        }
        if (outStream == null || !outStream.CanWrite)
        {
            return;
        }
        if (null == m_btsHeartBeatContent)
        {//心跳包内容不会变，缓存
            //TO Do
        }
        if (null == m_btsHeartBeatContent)
            return;
        outStream.BeginWrite(m_btsHeartBeatContent, 0, m_btsHeartBeatContent.Length, new AsyncCallback(OnWrite), null);
    }

    /// <summary>
    /// 发送数据
    /// </summary>
    void FlushSendBuffer()
    {
        if (_tcpclient == null || !_tcpclient.Connected)
        {
            return;
        }
        if (outStream == null || !outStream.CanWrite)
        {
            return;
        }
        if (m_quRequestMsgs == null || m_quRequestMsgs.Count == 0)
        {
            return;
        }
        //将m_quRequestMsgs内的消息一起提交，减少向socket提交次数
        m_stSendFmtBuffer.Reset();
        NNetMsgDef stMsgToSend = null;
        lock (m_quRequestMsgs)
        {
            while (m_quRequestMsgs.Count > 0)
            {
                stMsgToSend = m_quRequestMsgs.Peek();
                if (null == stMsgToSend)
                {
                    m_quRequestMsgs.Dequeue();
                    continue;
                }
                //判断发送缓冲容量
                if (m_stSendFmtBuffer.RemainWriteCapacity < stMsgToSend.Size)
                    break;//下次再发吧
                m_stSendFmtBuffer.Write(stMsgToSend.stHeader);
                m_stSendFmtBuffer.Write(stMsgToSend.btsData);
                m_quRequestMsgs.Dequeue();
            }
        }
        // 写入所有的BUFFER
        if(m_stSendFmtBuffer.WritePos > 0)
            outStream.BeginWrite(m_stSendFmtBuffer.Buffer, 0, (int)m_stSendFmtBuffer.WritePos, new AsyncCallback(OnWrite), null);
    }

    /// <summary>
    /// 向链接写入数据流
    /// </summary>
    void OnWrite(IAsyncResult r)
    {
        try
        {
            outStream.EndWrite(r);
        }
        catch (Exception e)
        {
            // 发送失败抛出异常,不作处理（#） 
            string str = string.Format("<Net> SendRequests OnWrite Error! {0}", e.Message);
            OnLog(str);
            OnExceptions(NNetExpType.SendRequestFailed);
        }
    }
    #endregion

    #region 接收RPC相关

    void OnRead(IAsyncResult asr)
    {
        try
        {
            int bytesRead = 0;
            //读取字节流到缓冲区
            bytesRead = outStream.EndRead(asr);
            if (bytesRead < 1)
            {
                OnDisconnected("<Net> OnDisconnected! bytesRead = 0");
                OnExceptions(NNetExpType.Disconnect);
                return;
            }
            else
            {
                //分析数据包内容，抛给逻辑层
                AddRecvedBytes(byteBuffer, bytesRead);
            }
            //分析完，再次监听服务器发过来的新消息
            //清空数组 
            Array.Clear(byteBuffer, 0, byteBuffer.Length);
            outStream.BeginRead(byteBuffer, 0, MAX_READ, new AsyncCallback(OnRead), null);
        }
        catch (Exception e)
        {
            string str = string.Format("<Net> OnRead Exception! {0}", e.Message);
            OnDisconnected(str);
            OnExceptions(NNetExpType.Disconnect);
            return;
        }
    }

    /// <summary>
    /// 接收到消息
    /// </summary>
    NNetMsgHeader m_stMsgHeader = new NNetMsgHeader();
    void AddRecvedBytes(byte[] bytes, int length)
    {
        if (length < 1)
            return;
        if (!m_stRecvBuffer.Write(bytes, (uint)length))
        {
            OnDisconnected(string.Format("<Net> OnReceive Exception! BufferSt:Cap:{0},WritePos:{1},ReadPos:{2}", m_stRecvBuffer.Capacity, m_stRecvBuffer.WritePos, m_stRecvBuffer.ReadPos));
            OnExceptions(NNetExpType.Disconnect);
            return;
        }
        while (true)
        {

            if (!m_stRecvBuffer.Read(ref m_stMsgHeader))
                break;
            if (m_stMsgHeader.sSize < NNetMsgHeader.sMsgHeadSize)//异常包
            {
                OnDisconnected("<Net> OnReceive Exception! m_stMsgHeader.sSize < 10");
                OnExceptions(NNetExpType.Disconnect);
                break;
            }
            //body 大小
            short usMsgBodySize = (short)(m_stMsgHeader.sSize - NNetMsgHeader.sMsgHeadSize);//除去包头大小
            uint unRemainRead = m_stRecvBuffer.RemainReadCapacity;
            if (unRemainRead < usMsgBodySize)
            {//恢复m_unReadPos
                m_stRecvBuffer.OffsetReadPos(-(NNetMsgHeader.sMsgHeadSize + 2));//!!加m_stMsgHeader.sSize 2字节
                break;//包没收完整
            }
            NNetMsgDef stRcvMsg = new NNetMsgDef(m_stMsgHeader, usMsgBodySize);
            //读取body数据块
            if (usMsgBodySize > 0)
            {
                m_stRecvBuffer.Read(stRcvMsg.btsData, (uint)usMsgBodySize);
            }
            lock (m_quResponseMsgs)
            {
                m_quResponseMsgs.Enqueue(stRcvMsg);
            }
        }
    }

    #endregion

    /// <summary>
    /// 解析消息（主线程）
    /// </summary>
    protected void OnPackedReceived(NNetMsgDef stMsg)
    {
        try
        {
            OnLog(string.Format("<Net> 收到消息 CmdID = {0} , Len = {1} ", stMsg.stHeader.sCmdID, stMsg.stHeader.sSize));
            if (null != m_callbkResponese)
            {
                m_callbkResponese(m_nTypeID, stMsg);
            }
            if (m_dTraceTimeout > 0.0 && m_lstNowSubmitMsgs.Count > 0)//解除等待
            {
                bool bUnlock = false;
                foreach (var v in m_lstNowSubmitMsgs)
                {
                    if (v.GetRespCmdID() == stMsg.stHeader.sCmdID)
                    {
                        bUnlock = true;
                        break;
                    }
                }
                if (bUnlock)
                {
                    m_dTraceTimeout = 0.0;
                    m_lstNowSubmitMsgs.Clear();//可以进行下次消息提交了
                    OnExceptions(NNetExpType.StopWait);
                }
            }
        }
        catch (Exception e)
        {
            OnLog(string.Format("<Net> OnPackedReceived Error! e.Message = {0}", e.Message));
            OnExceptions(NNetExpType.ReceivedError);
        }
    }

    #region 处理RESPONSE
   
    /// <summary>
    /// 底层异常的callback
    /// </summary>
    protected void ResponseException(NNetExpType eNetExp)
    {
        if (m_callbkExcpt != null)
        {
            try
            {
                m_callbkExcpt(m_nTypeID, eNetExp);
                //处理重发
                if (eNetExp == NNetExpType.SendTimeout || eNetExp == NNetExpType.SendRequestFailed)
                    Submit2NetCatch();
            }
            catch (Exception e)
            {
                string str = string.Format("<Net>ResponseException Net: exception caught in callback: {0}, trace : {1}", e.Message, e.StackTrace);
                OnLog(str);
            }
        }
    }
    #endregion

    #region 通用部分
    [NoToLua]
    public void Update(double dt = 0.017)
    {

        if(!IsLoseConnected & IsConnectionSuccessful)
            OnExceptions(NNetExpType.Disconnect);

        if (Application.internetReachability == NetworkReachability.NotReachable && IsConnectionSuccessful)
            OnExceptions(NNetExpType.Disconnect);

        //写入socket
        FlushSendBuffer();

        //处理收到的消息
        lock (m_quResponseMsgs)
        {
            //每帧最多处理8个包
            byte byProcMsgCount = 0;
            while (m_quResponseMsgs.Count > 0 && byProcMsgCount < 8)
            {
                var packet = m_quResponseMsgs.Dequeue();
                OnPackedReceived(packet);
                ++byProcMsgCount;
            }
        }

        //处理异常
        ProcNetExceptions();

        lock (_listLogs)
        {
            for (int i = 0; i < _listLogs.Count; ++i)
            {
                NDebug.LogWarn(_listLogs[i]);
            }
            _listLogs.Clear();
        }

        //超时判断
        if (m_dTraceTimeout > 0.0)
        {
            m_dTraceTimeout -= dt;
            if (m_dTraceTimeout <= 0.0)
            {
                OnExceptions(NNetExpType.SendTimeout);
            }
        }
    }

    void ProcNetExceptions()
    {
        lock (_listExceptions)
        {
            if (_listExceptions.Count < 1)
                return;
            ushort usCount = 0;
            if (_listExceptions.Count > m_ExpceptLoopList.Length)
                m_ExpceptLoopList = new NNetExpType[_listExceptions.Count];
            for (int i = 0; i < _listExceptions.Count; ++i)
                m_ExpceptLoopList[usCount++] = _listExceptions[i];
            _listExceptions.Clear();
            for (ushort s = 0; s < usCount; ++s)
            {
                if (null == m_ExpceptLoopList[s])
                    continue;
                ResponseException(m_ExpceptLoopList[s]);
            }
            
        }
    }
    /// <summary>
    /// 写日志
    /// </summary>
    /// <param name="msg"></param>
    void OnLog(string msg)
    {
        lock (_listLogs)
        {
            _listLogs.Add(msg);
        }
    }

    /// <summary>
    /// 记录异常
    /// </summary>
    /// <param name="msg"></param>
    void OnExceptions(NNetExpType e)
    {
        lock (_listExceptions)
        {
            if(!_listExceptions.Contains(e))//不重复加入
                _listExceptions.Add(e);
        }
    }

    /// <summary>
    /// 返回是否网络通畅
    /// </summary>
    /// <returns></returns>
    [NoToLua]
    public bool IsConnect()
    {
        return (_tcpclient != null && _tcpclient.Connected);
    }
    #endregion
}