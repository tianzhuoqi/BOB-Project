using System;
/*
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Linq;
using System.IO;
using System.ComponentModel;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Security.Cryptography;
using UnityEngine.SceneManagement;
* */

/// <summary>
/// 上传录制音频功能,暂时屏蔽,因为会申请权限
/// </summary>
/// 
public class NVoiceUpload
{
    /*
    public static string path = "Voice/";

    public static string GetPersistentFilePath(string filename)
    {
        string filepath;

        if (Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.OSXPlayer ||
            Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.WindowsPlayer)
        {
            filepath = Application.persistentDataPath + "/" + filename;
        }

        else if (Application.platform == RuntimePlatform.IPhonePlayer || Application.platform == RuntimePlatform.Android)
        {
            filepath = Application.persistentDataPath + "/" + filename;
        }
        else
        {
            filepath = Application.persistentDataPath + "/" + filename;
        }
        return filepath;
    }

    public static string GetPersistentFilePath()
    {
        string filepath;

        //http://www.cnblogs.com/vsirWaiter/p/5340284.html

        if (Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.OSXPlayer ||
            Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.WindowsPlayer)
        {
            filepath = "file://" + Application.persistentDataPath + "/" + path;
        }
        else if (Application.platform == RuntimePlatform.IPhonePlayer || Application.platform == RuntimePlatform.Android)
        {
            filepath = Application.persistentDataPath + "/" + path;
        }
        else
        {
            filepath = Application.persistentDataPath + "/" + path;
        }
        return filepath;
    }

    //上传视频到指定文件夹
    public void Upload(string name, string address, string userid, string password)
    {
        NFTPClient client = new NFTPClient(address, userid, password);
        System.Net.ServicePointManager.DefaultConnectionLimit = 1000;
        FileInfo f = new FileInfo(GetPersistentFilePath(name));

        client.FileUpload(f, NVoiceUpload.path, name);
        if (!client.FileCheckExist(NVoiceUpload.path, name))
        {
            NDebug.LogDebug("Upload Feild");
        }
        else
        {
            NDebug.LogDebug("Upload Finish");
        }
    }
        
    //下载视频到本地
    public void Download(string localpath, string name, string address, string userid, string password)
    {
        NFTPClient client = new NFTPClient(address, userid, password);
        client.FileDownload(localpath, name, NVoiceUpload.path, name);
    }
     * */
}