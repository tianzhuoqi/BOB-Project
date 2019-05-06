using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
/*
 * 自动生成Panel和Mediator
 */
public class UIPanelCreate : Editor
{
    [MenuItem("Project Tools/NGUI/Gen UI Lua Panel and Mediator", false, 10)]
    public static void GenUILuaCreate()
    {
        bool isError = false;
        Object[] objs = Selection.GetFiltered(typeof(Object), SelectionMode.DeepAssets);
        int nTotal = objs.Length;
        int nProcCount = 0;
        foreach (UnityEngine.Object obj in objs)
        {
            if (obj == null) continue;
            GameObject gobj = obj as GameObject;
            if (null == gobj) continue;
            UIPanel isUI = gobj.GetComponent<UIPanel>();
            nProcCount++;
            EditorUtility.DisplayProgressBar("Gen UI Lua Panel and Mediator...", "", nProcCount * 1.0f / nTotal);
            if (isUI == null)
            {
                continue;
            }

            NLuaUIPanelBase luaPanel = gobj.GetComponent<NLuaUIPanelBase>();
            if (luaPanel == null)
            {
                isError = true;
                Debug.LogError("请添加NLuaUIPanelBase组件");
                continue;
            }

            m_ModuleName = luaPanel.m_modelPathName;

            if (string.IsNullOrEmpty(m_ModuleName) || !CheckModuleName(m_ModuleName))
            {
                isError = true;
                Debug.LogError("NLuaUIPanelBase ModelPathName不正确，请检测");
                continue;
            }
            
            luaPanel.LuaClassName = GetPanelClassName(gobj);

            try
            {
                if (!CreateUIPanelLuaScript(gobj))
                {
                    isError = true;
                    Debug.LogError(string.Format("CreateUIPanelLuaScript failed {0}", gobj.name));
                    break;
                }

                if (!CreateUIMediatorLuaScript(gobj))
                {
                    isError = true;
                    Debug.LogError(string.Format("CreateUIMediatorLuaScript failed {0}", gobj.name));
                    break;
                }
            }
            catch (System.Exception e)
            {
                Debug.LogError(e.Message);
                break;
            }
        }

        EditorUtility.ClearProgressBar();
        if (!isError)
        {
            Debug.Log("Gen UI Lua Panel and Mediator Complete！");
        }
    }

    static bool CheckModuleName(string moduleName)
    {
        if (moduleName == "SLoading" ||
            moduleName == "SLogin" ||
            moduleName == "SPlanetary" ||
            moduleName == "SUniverse" ||
            moduleName == "SUpdate")
        {
            return true;
        }
        return false;
    }

    static string GetPanelClassName(GameObject obj)
    {
        return obj.name;
    }

    static string GetMediatorClassName(string panelName)
    {
        return panelName.Replace("Panel", "Mediator");
    }

    static string GetBinderClassName(string panelName)
    {
        return panelName + "Binder";
    }

    static string m_ModuleName = string.Empty;
    static string GetModuleName()
    {
        return m_ModuleName;
    }

    static bool CreateUIPanelLuaScript(GameObject obj)
    {
        if (obj == null) return false;
        string strPanelLuaClassN = GetPanelClassName(obj);
        string strMediatorLuaClassN = GetMediatorClassName(strPanelLuaClassN);
        string strBinderLuaClassN = GetBinderClassName(strPanelLuaClassN);
        string strModule = GetModuleName();
        string strOutputPath = LuaUIScriptPath;
        if (!Directory.Exists(strOutputPath))
        {
            Directory.CreateDirectory(strOutputPath);
        }

        string luapath = Path.Combine(strOutputPath, strPanelLuaClassN + ".lua");
        if (File.Exists(luapath))
        {
            return true;
        }

        string strFileContent = string.Empty;
        strFileContent += "local " + strMediatorLuaClassN + " = require(\"Game/Module/" + strModule + "/" + strMediatorLuaClassN + "\")\n";
        strFileContent += "local " + strPanelLuaClassN + " = register(\"" + strPanelLuaClassN + "\", PanelBase)\n";
        strFileContent += "local " + strBinderLuaClassN + " = require(\"UIDef/" + strBinderLuaClassN + "\")\n\n";

        strFileContent += "function " + strPanelLuaClassN + ":Awake(gameObject)\n";
        strFileContent += "\t" + strPanelLuaClassN + ".super.Awake(self, gameObject)\n";
        strFileContent += "\tself.uiBinder = " + strBinderLuaClassN + ".New(self.gameObject)\n\n";
        strFileContent += "\tself.mediator = " + strMediatorLuaClassN + ".New(NotiConst." + strMediatorLuaClassN + ")\n";
        strFileContent += "\tself.mediator:SetViewComponent(self)\n";
        strFileContent += "\tFacade:RegisterMediator(self.mediator)\n";
        strFileContent += "end\n\n";


        strFileContent += "function " + strPanelLuaClassN + ":OpenPanel()\n";
        strFileContent += "\t" + strPanelLuaClassN + ".super.OpenPanel(self)\n";
        strFileContent += "\tself:DoBlur()\n";
        strFileContent += "end\n\n";

        strFileContent += "return " + strPanelLuaClassN;

        //Create Script File
        FileStream fs = new FileStream(luapath, FileMode.Create);
        var utf8WithoutBom = new System.Text.UTF8Encoding(false);
        StreamWriter sw = new StreamWriter(fs, utf8WithoutBom);
        sw.Write(strFileContent);
        sw.Flush();
        sw.Close();
        return true;
    }

    static bool CreateUIMediatorLuaScript(GameObject obj)
    {
        if (obj == null) return false;
        string strPanelLuaClassN = GetPanelClassName(obj);
        string strMediatorLuaClassN = GetMediatorClassName(strPanelLuaClassN);
        string strOutputPath = LuaUIScriptPath;
        if (!Directory.Exists(strOutputPath))
        {
            Directory.CreateDirectory(strOutputPath);
        }

        string luapath = Path.Combine(strOutputPath, strMediatorLuaClassN + ".lua");
        if (File.Exists(luapath))
        {
            return true;
        }

        string strFileContent = string.Empty;
        strFileContent += "local " + strMediatorLuaClassN + " = class(\"" + strMediatorLuaClassN + "\", MediatorDynamic)\n\n";

        strFileContent += "function " + strMediatorLuaClassN + ":OnRegister()\n\n";
        strFileContent += "end\n\n";

        strFileContent += "return " + strMediatorLuaClassN;

        //Create Script File
        FileStream fs = new FileStream(luapath, FileMode.Create);
        var utf8WithoutBom = new System.Text.UTF8Encoding(false);
        StreamWriter sw = new StreamWriter(fs, utf8WithoutBom);
        sw.Write(strFileContent);
        sw.Flush();
        sw.Close();
        return true;
    }

    static string LuaUIScriptPath
    {
        get
        {
            string n_scriptPath = Path.GetFullPath(Application.dataPath + "/ResourcesAssets/Lua/Game/Module/" + GetModuleName());
            if (!Directory.Exists(n_scriptPath))
            {
                Directory.CreateDirectory(n_scriptPath);
            }
            return n_scriptPath;
        }
    }
}
