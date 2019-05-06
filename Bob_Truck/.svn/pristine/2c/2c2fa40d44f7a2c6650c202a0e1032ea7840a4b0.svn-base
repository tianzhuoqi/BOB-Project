using System;
using System.Text;
using System.IO;
using System.Collections.Generic;

/*
 * 内存字节操作类，分别记录读位置与写位置，读位置不会超过写位置
*/

public class NMemeryStream
{
    byte[] m_byBuffer = null;   //数据缓存
    uint m_unCapacity = 0;    //容量
    uint m_unWritePos = 0;    //写入位置
    uint m_unReadPos = 0;     //读出位置
    bool m_bRevrtMSB_LSB = true; //是否转换大小端
    public NMemeryStream(uint capacity, bool bRevert = true)
    {
        m_bRevrtMSB_LSB = bRevert;
        if (capacity < 1)
            capacity = 64;
        m_byBuffer = new byte[capacity];
        m_unCapacity = capacity;
    }
    public uint Capacity { get { return m_unCapacity; } }
    public byte[] Buffer { get { return m_byBuffer; } }
    public uint WritePos { get { return m_unWritePos; } }
    public uint ReadPos { get { return m_unReadPos; } }
    public uint RemainWriteCapacity { get { return m_unCapacity >= m_unWritePos ? (m_unCapacity - m_unWritePos) : 0; } } //剩余写入容量
    public uint RemainReadCapacity { get { return m_unWritePos >= m_unReadPos ? (m_unWritePos - m_unReadPos) : 0; } } //剩余读出容量

    public void OffsetReadPos(int offset)
    {
        if (offset < 0)
        {
            uint unAbsOffset = (uint)Math.Abs(offset);
            if (unAbsOffset > m_unReadPos)
                m_unReadPos = 0;
            else
                m_unReadPos -= unAbsOffset;
        }
        else
        {
            m_unReadPos += (uint)offset;
            if (m_unReadPos > m_unWritePos)
                m_unReadPos = m_unWritePos;
        }
    }
    //写入容量检测
    bool EnsureWriteCapacity(uint increament)
    {
        if (RemainWriteCapacity >= increament) 
            return true;
        try
        {
            //写入容量不够的情况下
            //1.通过移动Write&Read pos(将Read与Write之间的数据，复制到buffer起始处)将空闲内存重用
            uint unRemainRead = RemainReadCapacity;
            if (unRemainRead > 0)
                Array.Copy(m_byBuffer, (int)m_unReadPos, m_byBuffer, 0, (int)unRemainRead);
            
            //重置读写位置
            m_unWritePos = unRemainRead;
            m_unReadPos = 0;
            //重新判断容量
            if (RemainWriteCapacity >= increament)
                return true;

            //2.扩充容量 & 复制原始数据
            uint unReqCapability = m_unCapacity + increament;
            uint unNewCapability = unReqCapability > m_unCapacity * 2 ? unReqCapability : m_unCapacity * 2;
            byte[] byNewBuffer = new byte[unNewCapability];
            Array.Copy(m_byBuffer, byNewBuffer, m_unCapacity);
            m_byBuffer = byNewBuffer;
            m_unCapacity = unNewCapability;
        }
        catch (Exception e)
        {
            NDebug.LogWarn(e.Message);
            return false;
        }
        return true;
    }

    #region 写入
    public bool Write(byte bt)
    {
        if (!EnsureWriteCapacity(sizeof(byte)))
            return false;
        m_byBuffer[m_unWritePos++] = bt;
        return true;
    }

    public bool Write(ushort us)
    {
        if (!EnsureWriteCapacity(sizeof(ushort)))
            return false;
        if (m_bRevrtMSB_LSB)
            us = (ushort)ReverseBytes((UInt16)us);
        byte[] bts = BitConverter.GetBytes(us);
        return Write(bts);
    }

    public bool Write(short s)
    {
        if (!EnsureWriteCapacity(sizeof(short)))
            return false;
        if (m_bRevrtMSB_LSB)
            s = (short)ReverseBytes((UInt16)s);
        byte[] bts = BitConverter.GetBytes(s);
        return Write(bts);
    }

    public bool Write(uint un)
    {
        if (!EnsureWriteCapacity(sizeof(uint)))
            return false;
        if (m_bRevrtMSB_LSB)
            un = (uint)ReverseBytes((UInt32)un);
        byte[] bts = BitConverter.GetBytes(un);
        return Write(bts);
    }

    public bool Write(int n)
    {
        if (!EnsureWriteCapacity(sizeof(int)))
            return false;
        if (m_bRevrtMSB_LSB)
            n = (int)ReverseBytes((UInt32)n);
        byte[] bts = BitConverter.GetBytes(n);
        return Write(bts);
    }

    public bool Write(ulong ul)
    {
        if (!EnsureWriteCapacity(sizeof(ulong)))
            return false;
        if (m_bRevrtMSB_LSB)
            ul = (ulong)ReverseBytes((UInt64)ul);
        byte[] bts = BitConverter.GetBytes(ul);
        return Write(bts);
    }

    public bool Write(long l)
    {
        if (!EnsureWriteCapacity(sizeof(long)))
            return false;
        if (m_bRevrtMSB_LSB)
            l = (long)ReverseBytes((UInt64)l);
        byte[] bts = BitConverter.GetBytes(l);
        return Write(bts);
    }

    public bool Write(byte[] bytes)
    {
        if (null == bytes || bytes.Length < 1)
            return false;
        uint unWriteLen = (uint)bytes.Length;
        if (!EnsureWriteCapacity(unWriteLen))
            return false;
        try
        {
            Array.Copy(bytes, 0, m_byBuffer, m_unWritePos, (int)unWriteLen);
            m_unWritePos += unWriteLen;
        }
        catch (Exception e)
        {
            NDebug.LogWarn(e.Message);
            return false;
        }
        return true;
    }

    public bool Write(byte[] bytes, uint unLength)
    {
        if (null == bytes || bytes.Length < 1)
            return false;
        uint unWriteLen = unLength;
        if (unWriteLen > (uint)bytes.Length)
            return false;
        if (!EnsureWriteCapacity(unWriteLen))
            return false;
        try
        {
            Array.Copy(bytes, 0, m_byBuffer, m_unWritePos, (int)unWriteLen);
            m_unWritePos += unWriteLen;
        }
        catch (Exception e)
        {
            NDebug.LogWarn(e.Message);
            return false;
        }
        return true;
    }

    //将一个4位整数以变长压缩的方式写入缓存
    public bool WriteVariant32(int nVariant)
    {
        while (nVariant > 127)
        {
            if (!Write((byte)((nVariant & 0x7f) | 0x80)))
                return false;
            nVariant >>= 7;
        }
        if (!Write((byte)nVariant))
            return false;
        return true;
    }

    //写入包头
    public bool Write(NNetMsgHeader header)
    {
        if (!Write(header.sSize))
            return false;
        //if (!Write(header.lUserID))
        //    return false;
        if (!Write(header.sCmdID))
            return false;
        return true;
    }

    #endregion

    #region 读出
    public bool Read(out byte bt)
    {
        bt = 0;
        if (RemainReadCapacity < sizeof(byte))
            return false;
        bt = m_byBuffer[m_unReadPos++];
        return true;
    }

    public bool Read(out ushort us)
    {
        us = 0;
        if (RemainReadCapacity < sizeof(ushort))
            return false;
        us = BitConverter.ToUInt16(m_byBuffer, (int)m_unReadPos);
        if (m_bRevrtMSB_LSB)
            us = (ushort)ReverseBytes((UInt16)us);
        m_unReadPos += sizeof(ushort);
        return true;
    }

    public bool Read(out short s)
    {
        s = 0;
        if (RemainReadCapacity < sizeof(short))
            return false;
        s = BitConverter.ToInt16(m_byBuffer, (int)m_unReadPos);
        if (m_bRevrtMSB_LSB)
            s = (short)ReverseBytes((UInt16)s);
        m_unReadPos += sizeof(short);
        return true;
    }

    public bool Read(out uint un)
    {
        un = 0;
        if (RemainReadCapacity < sizeof(uint))
            return false;
        un = BitConverter.ToUInt32(m_byBuffer, (int)m_unReadPos);
        if (m_bRevrtMSB_LSB)
            un = (uint)ReverseBytes((UInt32)un);
        m_unReadPos += sizeof(uint);
        return true;
    }

    public bool Read(out int n)
    {
        n = 0;
        if (RemainReadCapacity < sizeof(int))
            return false;
        n = BitConverter.ToInt32(m_byBuffer, (int)m_unReadPos);
        if (m_bRevrtMSB_LSB)
            n = (int)ReverseBytes((UInt32)n);
        m_unReadPos += sizeof(int);
        return true;
    }

    public bool Read(out ulong ul)
    {
        ul = 0;
        if (RemainReadCapacity < sizeof(ulong))
            return false;
        ul = BitConverter.ToUInt64(m_byBuffer, (int)m_unReadPos);
        if (m_bRevrtMSB_LSB)
            ul = (ulong)ReverseBytes((UInt64)ul);
        m_unReadPos += sizeof(ulong);
        return true;
    }

    public bool Read(out long l)
    {
        l = 0;
        if (RemainReadCapacity < sizeof(long))
            return false;
        l = BitConverter.ToInt64(m_byBuffer, (int)m_unReadPos);
        if (m_bRevrtMSB_LSB)
            l = (long)ReverseBytes((UInt64)l);
        m_unReadPos += sizeof(long);
        return true;
    }

    public bool Read(byte[] btsOut, uint nBytesCount)
    {
        if (null == btsOut || btsOut.Length < nBytesCount)
            return false;
        if (RemainReadCapacity < nBytesCount)
            return false;
        try
        {
            Array.Copy(m_byBuffer, (int)m_unReadPos, btsOut, 0, nBytesCount);
            m_unReadPos += nBytesCount;
        }
        catch (Exception e)
        {
            NDebug.LogWarn(e.Message);
            return false;
        }
        return true;
    }

    //尝试读取一个被压缩的变长int32,不改变ReadPos
    public bool TryReadVariant32(ref int nOutVariant32, ref int nBytesCount)
    {
        nOutVariant32 = 0;
        nBytesCount = 0;
        int shift = 0;
        uint unTempReadPos = m_unReadPos;
        while (unTempReadPos < m_unWritePos)
        {
            byte bt = m_byBuffer[unTempReadPos++];
            ++nBytesCount;
            nOutVariant32 |= ((bt & 0x7f) << shift);
            shift += 7;
            if ((bt & 0x80)==0)
                break;
        }
        return true;
    }

    //尝试读取包头
    public bool Read(ref NNetMsgHeader header)
    {
        //保存原始Read Pos,在读取不成功时恢复
        uint unPreReadPos = m_unReadPos;
        do
        {
            if (!Read(out header.sSize))
                break;
            //if (!Read(out header.lUserID))
            //    break;
            if (!Read(out header.sCmdID))
                break;
            return true;
        }
        while (false);
        //失败
        m_unReadPos = unPreReadPos;
        return false;
    }

    #endregion

    public void Reset()
    {
        m_unReadPos = 0;
        m_unWritePos = 0;
    }


    // 翻转字节顺序 (16-bit)
    public static UInt16 ReverseBytes(UInt16 value)
    {
        return (UInt16)((value & 0xFFU) << 8 | (value & 0xFF00U) >> 8);
    }


    // 翻转字节顺序 (32-bit)
    public static UInt32 ReverseBytes(UInt32 value)
    {
        return (value & 0x000000FFU) << 24 | (value & 0x0000FF00U) << 8 |
               (value & 0x00FF0000U) >> 8 | (value & 0xFF000000U) >> 24;
    }


    // 翻转字节顺序 (64-bit)
    public static UInt64 ReverseBytes(UInt64 value)
    {
        return (value & 0x00000000000000FFUL) << 56 | (value & 0x000000000000FF00UL) << 40 |
               (value & 0x0000000000FF0000UL) << 24 | (value & 0x00000000FF000000UL) << 8 |
               (value & 0x000000FF00000000UL) >> 8 | (value & 0x0000FF0000000000UL) >> 24 |
               (value & 0x00FF000000000000UL) >> 40 | (value & 0xFF00000000000000UL) >> 56;
    }
}