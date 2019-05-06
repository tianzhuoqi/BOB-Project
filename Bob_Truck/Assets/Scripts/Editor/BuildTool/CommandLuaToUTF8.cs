using UnityEngine;  
using UnityEditor;  
using System.IO;  
using System.Text;

/// <summary>  
/// 这个是lua文件转化为UTF-8格式的工具  
/// </summary>  
public class CommandLuaToUTF8 : EditorWindow 
{
    private const string EDITOR_VERSION = "v1.0";
    private Vector2 m_scrollPos;

    private string m_luaPath = "/ResourcesAssets/Lua/";
    private string m_fileSuffix = ".lua";
  
    /// <summary>  
    /// 数据目录  
    /// </summary>  
    static string AppDataPath  
    {  
        get { return Application.dataPath.ToLower(); }  
    }

    [MenuItem("Project Tools/Build Tools/Lua File to UTF-8 Encoding And Check")]
    static void Init()  
    {  
        Debug.Log("初始化转化lua文件为UTF-8格式,静态检查lua语法");
        EditorWindow.GetWindow(typeof(CommandLuaToUTF8));  
    }
  
    void OnGUI()  
    {  
        m_scrollPos = GUILayout.BeginScrollView(m_scrollPos, GUILayout.Width(Screen.width), GUILayout.Height(Screen.height));  
        GUILayout.BeginVertical();
        GUILayout.BeginHorizontal();  

        GUILayout.Label("要转化的路径: ");
        m_luaPath = GUILayout.TextField(m_luaPath, 64);  
        GUILayout.EndHorizontal();  
        GUILayout.BeginHorizontal();  

        GUILayout.Label("文件后缀: ");
        m_fileSuffix = GUILayout.TextField(m_fileSuffix, 64);  
        GUILayout.EndHorizontal();  

        if (GUILayout.Button("\n 文件转utf-8 NO BOM格式 \n"))
        {  
            this.Conversion();  
        }
        if (GUILayout.Button("\n 静态检查lua的语法 \n"))
        {
            string path = Application.dataPath + "/Scripts/Editor/BuildTool/CheckLua.bat";
            Application.OpenURL(path);
        }
        GUILayout.Space(15);  
        GUILayout.Label("工具版本号: " + EDITOR_VERSION);

        GUILayout.EndVertical();
        GUILayout.EndScrollView();  
    }  
  
    // 开始转化  
    private void Conversion()  
    {  
        if (m_luaPath.Equals(string.Empty))  
        {  
            return;  
        }  
  
        if (!IsFolderExists(m_luaPath)) {  
            Debug.LogError("找不到文件夹路径！");  
            return;  
        }  
  
        string path = AppDataPath + m_luaPath;  
        string[] files = Directory.GetFiles(path, "*", SearchOption.AllDirectories);  
        foreach (string file in files)  
        {  
            if (!file.EndsWith(m_fileSuffix)) continue;  
            string strTempPath = file.Replace(@"\", "/");  
            Debug.Log("文件路径：" + strTempPath);  
            ConvertFileEncoding(strTempPath, null, new UTF8Encoding(false));  
        }  
  
        AssetDatabase.Refresh();  
        Debug.Log("格式转换完成！");  
    }  
  
    /// 检测是否存在文件夹  
    private static bool IsFolderExists(string folderPath)  
    {  
        if (folderPath.Equals(string.Empty))  
        {  
            return false;  
        }  
  
        return Directory.Exists(GetFullPath(folderPath));  
    }  
  
    /// 返回Application.dataPath下完整目录  
    private static string GetFullPath(string srcName)  
    {  
        if (srcName.Equals(string.Empty))  
        {  
            return Application.dataPath;  
        }  
  
        if (srcName[0].Equals('/'))  
        {  
            srcName.Remove(0, 1);  
        }  
  
        return Application.dataPath + "/" + srcName;  
    }  
  
    /// <summary>  
    /// 文件编码转换  
    /// </summary>  
    /// <param name="sourceFile">源文件</param>  
    /// <param name="destFile">目标文件，如果为空，则覆盖源文件</param>  
    /// <param name="targetEncoding">目标编码</param>  
    private static void ConvertFileEncoding(string sourceFile, string destFile, Encoding targetEncoding)  
    {  
        destFile = string.IsNullOrEmpty(destFile) ? sourceFile : destFile;  
        File.WriteAllText(destFile, File.ReadAllText(sourceFile, Encoding.UTF8), targetEncoding);  
    }  
}  
