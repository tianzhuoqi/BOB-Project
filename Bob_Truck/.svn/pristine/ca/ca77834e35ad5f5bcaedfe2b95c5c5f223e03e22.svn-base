using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Google.ProtocolBuffers;

using System.Security.Cryptography;

public class NRpcParams : List<byte[]>
{
    public NRpcParams AddData(IMessageLite[] data)
    {
        foreach (var item in data)
        {
            this.Add(item.ToByteArray());
        }
        return this;
    }

    public static NRpcParams CreateRpcParams(IMessageLite[] data)
    {
        var ret = new NRpcParams();
        ret.AddData(data);
        return ret;
    }

    public static NRpcParams CreateRpcParams(IMessageLite data)
    {
        var ret = new NRpcParams();
        ret.Add(data.ToByteArray());
        return ret;
    }

    public static NRpcParams Clone(NRpcParams data)
    {
        var ret = new NRpcParams();
        for (int i = 0; i < data.Count; ++i)
            ret.Add(data[i]);
        return ret;
    }

    #region 对称加密网络消息相关
    public static string key = "7e9ac96224894b058423953401c20de0";
    public static byte[] bKey = Encoding.UTF8.GetBytes(key.Substring(0, 8));
    public static byte[] bIV = Encoding.UTF8.GetBytes(key.Substring(24, 8));

    public static byte[] Encrypt(byte[] src)
    {
        try
        {
            DESCryptoServiceProvider desc = new DESCryptoServiceProvider();
            MemoryStream mStream = new MemoryStream();
            CryptoStream cStream = new CryptoStream(mStream, desc.CreateEncryptor(bKey, bIV), CryptoStreamMode.Write);
            cStream.Write(src, 0, src.Length);
            cStream.FlushFinalBlock();
            return mStream.ToArray();
        }
        catch
        {
            return null;
        }
    }

    public static byte[] Decrypt(byte[] src)
    {
        try
        {
            DESCryptoServiceProvider desc = new DESCryptoServiceProvider();
            MemoryStream mStream = new MemoryStream();
            CryptoStream cStream = new CryptoStream(mStream, desc.CreateDecryptor(bKey, bIV), CryptoStreamMode.Write);
            cStream.Write(src, 0, src.Length);
            cStream.FlushFinalBlock();
            return mStream.ToArray();
        }
        catch
        {
            return null;
        }
    }
    #endregion
};

//消息段定义 一个消息由一个short表示
//requset必有相应的response,req与resp对应关系为resp=req+10000,commond没有
public enum EMsgIDSegment
{
    eMsgIDC2S_ReqBegin   = 1001,       //客户端req起始
    eMsgIDC2S_ReqEnd     = 6000,       //客户端req结束
    eMsgIDC2S_CmdBegin   = 6001,       //客户端cmd起始
    eMsgIDC2S_CmdEnd     = 11000,      //客户端cmd结束
    eMsgIDS2C_RespBegin  = 11001,      //服务端resp开始
    eMsgIDS2C_RespEnd    = 16000,      //服务端resp结束
};

//消息包头定义 固定2字节 
public class NNetMsgHeader
{
    public static readonly short sMsgHeadSize = 2;
    public short sSize; //!!这个size包括sCmdID+bodysize
    public short sCmdID;
    //public long lUserID;
    public NNetMsgHeader()
    {
        sSize = sMsgHeadSize;
    }
    public NNetMsgHeader(short sCmdID, short sDataSize)
    {
        this.sCmdID = sCmdID;
        //this.lUserID = lUserID;
        this.sSize = (short)(sMsgHeadSize + sDataSize);
    }
};

//消息定义
public class NNetMsgDef
{
    public NNetMsgHeader stHeader = new NNetMsgHeader();
    public byte[] btsData = null;
    public NNetMsgDef(NNetMsgHeader header, short sDataSize)
    {
        if (sDataSize > 0)
            btsData = new byte[sDataSize];
        stHeader.sCmdID = header.sCmdID;
        //stHeader.lUserID = header.lUserID;
        stHeader.sSize = header.sSize;
    }

    //构建消息包
    public static NNetMsgDef Create(short sCmdID, byte[] bts)
    {
        short sDataSize = 0;
        if (null != bts)
            sDataSize = (short)bts.Length;
        NNetMsgHeader header = new NNetMsgHeader(sCmdID, sDataSize);
        NNetMsgDef stMsg = new NNetMsgDef(header, sDataSize);
        if (sDataSize > 0)
        {
            Array.Copy(bts, 0, stMsg.btsData, 0, sDataSize);
        }
        return stMsg;
    }

    public short GetRespCmdID()
    {
        //如果这个消息没有resp
        if (stHeader.sCmdID < (short)EMsgIDSegment.eMsgIDC2S_ReqBegin ||
            stHeader.sCmdID > (short)EMsgIDSegment.eMsgIDC2S_ReqEnd)
        {
            return 0;
        }
        //定义request cmdid与 resp cmdi的映射
        return (short)(stHeader.sCmdID + 1000);
    }
    // 返回整个包的大小
    public ushort Size { get { return (ushort)(stHeader.sSize + NNetMsgHeader.sMsgHeadSize); } }
};

//网络异常类型
public enum NNetExpType
{
    OnConnectSucceed = 0,         //连接成功

    ConnectFailed  = 1,         //连接失败（客户端问题为主）
    OnConnectFailed,            //无法连接（服务器问题为主）
    SendRequestFailed,          //发送失败
    Disconnect,                //断开（各种原因连接后又断开连接了）
    ReceivedError,             //收到错误的包，无法解析
    SendTimeout,               //发送超时

    //提示
    StartWait = 1000,           //开始跑小人
    StopWait,                  //停止跑小人
}

//RPC delegate
public delegate void DelegateResponseRPCHandler(int nNetType, NNetMsgDef stMsg);
public delegate void DelegateRPCExceptHandler(int nNetType, NNetExpType e);
public delegate void DelegateNetMsgHandler(NNetMsgDef stMsg);//逻辑层消息处理