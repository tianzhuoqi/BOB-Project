using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using LuaInterface;

public class NLanguage
{
    static public int GetCurrentLanguage()
    {
        // 获取默认语言,如果没有获取到,就默认英文
        SystemLanguage current = (SystemLanguage)PlayerPrefs.GetInt("CurrentLanguage", (int)SystemLanguage.Unknown);
        if (current == SystemLanguage.Unknown)
            current = SystemLanguage.English;
        PlayerPrefs.SetInt("CurrentLanguage", (int)current);
        PlayerPrefs.Save();

        // 特别注意繁体unity无法获取,需要自己再做二次判断,并且返回200(Zh_hant)
        return (int)current;
    }
}
