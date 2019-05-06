using UnityEditor;
using UnityEngine;
using System.IO;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

public class CommandTextUTF8
{
    private static string TextPath = Application.dataPath + @"/ResourcesAssets/Text";
    // [MenuItem("Project Tools/BuildTool/ChangeUTF-8")]
    public static void Change()
    {
        ChangeUTF8();
    }

    private static void ChangeUTF8()
    {
        GetDirectory(TextPath);
        AssetDatabase.Refresh();
    }

    private static void GetDirectory(string path)
    {
        DirectoryInfo folder = new DirectoryInfo(path);
        if (folder != null)
        {
            foreach (var directory in folder.GetDirectories())
            {
                GetDirectory(directory.FullName);
            }

            foreach (var file in folder.GetFileSystemInfos())
            {
                if (file.Name.EndsWith(".bytes"))
                {
                    System.Text.Encoding encoding = GetType(new System.IO.FileStream(file.FullName, System.IO.FileMode.Open, System.IO.FileAccess.Read));
                    if (encoding != System.Text.Encoding.UTF8)
                    {
                        System.IO.FileStream fs = new System.IO.FileStream(file.FullName, System.IO.FileMode.Open, System.IO.FileAccess.Read);
                        byte[] flieByte = new byte[fs.Length];
                        fs.Read(flieByte, 0, flieByte.Length);
                        fs.Close();

                        StreamWriter docWriter;
                        System.Text.Encoding ec = System.Text.Encoding.GetEncoding("UTF-8");
                        docWriter = new StreamWriter(file.FullName, false, ec);
                        docWriter.Write(encoding.GetString(flieByte));
                        docWriter.Close();
                    }
                }
            }
        }
    }

    /// <summary> 
    /// 判断是否是不带BOM的UTF8 格式 
    /// </summary> 
    /// <param name=“data“></param> 
    /// <returns></returns> 
    private static bool IsUTF8Bytes(byte[] data)
    {
        int charByteCounter = 1; //计算当前正分析的字符应还有的字节数 
        byte curByte; //当前分析的字节. 
        for (int i = 0; i < data.Length; i++)
        {
            curByte = data[i];
            if (charByteCounter == 1)
            {
                if (curByte >= 0x80)
                {
                    //判断当前 
                    while (((curByte <<= 1) & 0x80) != 0)
                    {
                        charByteCounter++;
                    }
                    //标记位首位若为非0 则至少以2个1开始 如:110XXXXX...........1111110X 
                    if (charByteCounter == 1 || charByteCounter > 6)
                    {
                        return false;
                    }
                }
            }
            else
            {
                //若是UTF-8此时第一位必须为1 
                if ((curByte & 0xC0) != 0x80)
                {
                    return false;
                }
                charByteCounter--;
            }
        }
        if (charByteCounter > 1)
        {
            throw new System.Exception("非预期的byte格式");
        }
        return true;
    }

    private static System.Text.Encoding GetType(FileStream fs)
    {
        //byte[] Unicode = new byte[] { 0xFF, 0xFE, 0x41 };
        //byte[] UnicodeBIG = new byte[] { 0xFE, 0xFF, 0x00 };
        //byte[] UTF8 = new byte[] { 0xEF, 0xBB, 0xBF }; //带BOM 
        Encoding reVal = Encoding.Default;

        BinaryReader r = new BinaryReader(fs, System.Text.Encoding.Default);
        int i;
        int.TryParse(fs.Length.ToString(), out i);
        byte[] ss = r.ReadBytes(i);
        if (IsUTF8Bytes(ss) || (ss[0] == 0xEF && ss[1] == 0xBB && ss[2] == 0xBF))
        {
            reVal = Encoding.UTF8;
        }
        else if (ss[0] == 0xFE && ss[1] == 0xFF && ss[2] == 0x00)
        {
            reVal = Encoding.BigEndianUnicode;
        }
        else if (ss[0] == 0xFF && ss[1] == 0xFE && ss[2] == 0x41)
        {
            reVal = Encoding.Unicode;
        }
        r.Close();
        return reVal;
    } 
}
