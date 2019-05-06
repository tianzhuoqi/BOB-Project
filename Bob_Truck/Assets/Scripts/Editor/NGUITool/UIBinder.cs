using System.Collections.Generic;
using System.IO;
using System.Reflection;
using UnityEditor;
using UnityEngine;
/*
 * UI自动绑定
 */
class UIBinder : Editor
{
    [MenuItem("Project Tools/NGUI/Gen UI Lua Binder", false, 10)]
    public static void GenUILuaBinder()
    {
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
            EditorUtility.DisplayProgressBar("Gen UI Lua Binder...", "", nProcCount * 1.0f / nTotal);
            if (isUI == null)
                continue;
            try
            {
                if (!CreateUILuaScript(gobj))
                {
                    Debug.LogWarning(string.Format("CreateUILuaScript failed {0}", gobj.name));
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
        Debug.Log("Gen UI Lua Binder Complete！");
    }
    static string GetBinderClassName(GameObject obj)
    {
        return obj.name + "Binder";
    }

    static string GetFieldType(GameObject obj)
    {
        foreach (Component com in obj.GetComponents<Component>())
        {
            if (com == null) continue;
            string comName = com.GetType().Name;
            if (comName.Equals("UILabel") && obj.GetComponent<UIInput>())
            {
                return "UIInput";
            }
            if (comName == "UILabel" ||
                comName == "UISprite" ||
                comName == "UIButton" ||
                comName == "UITexture" ||
                comName == "UISlider" ||
                comName == "Camera")
                return comName;
        }
        return string.Empty;
    }

    static bool CreateUILuaScript(GameObject obj)
    {
        if (obj == null) return false;
        string strLuaClassN = GetBinderClassName(obj);
        string strOutputPath = LuaUIDefScriptPath;
        if (!Directory.Exists(strOutputPath))
            Directory.CreateDirectory(strOutputPath);
        string luapath = Path.Combine(strOutputPath, strLuaClassN + ".lua");

        //收集兴趣变量 m_打头
        string objName;
        string fieldName;
        List<Transform> lstObjs = new List<Transform>();
        List<string> lstVarType = new List<string>();
        List<string> lstVarName = new List<string>();
        Transform[] tfs = obj.GetComponentsInChildren<Transform>(true);
        foreach (Transform tran in tfs)
        {
            objName = tran.name;
            fieldName = GetFieldType(tran.gameObject);
            if (objName.IndexOf("m_") != 0)
            {
                if (tran != obj.transform) continue;
                if (string.IsNullOrEmpty(fieldName)) continue;
                objName = "m_" + objName;
            }
            //if (string.IsNullOrEmpty(fieldName)) fieldName = "GameObject";
            lstObjs.Add(tran);
            lstVarType.Add(fieldName);
            if (lstVarName.Contains(objName))
            {
                Debug.LogError(string.Format("变量名重复 {0}", objName));
                return false;
            }
            lstVarName.Add(objName);
        }

        string strFileContent = string.Empty;
        strFileContent += "local " + strLuaClassN + " = class(\"" + strLuaClassN + "\");\n\n";

        //构造函数开始
        strFileContent += "function " + strLuaClassN + ":ctor(gameObject)\n";
        strFileContent += "\tlocal transform = gameObject.transform;\n";
        Transform trans = null;
        for (int i = 0; i < lstObjs.Count; i++)
        {
            trans = lstObjs[i];
            fieldName = lstVarType[i];
            objName = trans.name;
            if (trans == obj.transform)
            {
                if (string.IsNullOrEmpty(fieldName))
                    strFileContent += "\tself." + objName + " = gameObject;\n";
                else
                    strFileContent += "\tself." + objName + " = gameObject:GetComponent(\"" + fieldName + "\");\n";
            }
            else
            {
                string objPath = trans.name;
                Transform transTemp = trans;
                while (transTemp.parent != null && transTemp.parent != obj.transform)
                {
                    transTemp = transTemp.parent;
                    objPath = transTemp.name + "/" + objPath;
                }
                if (string.IsNullOrEmpty(fieldName))
                    strFileContent += "\tself." + objName + " = transform:Find(\"" + objPath + "\").gameObject;\n";
                else
                    strFileContent += "\tself." + objName + " = transform:Find(\"" + objPath + "\"):GetComponent(\"" + fieldName + "\");\n";
            }
        }
        //构造函数结束
        strFileContent += "end\n";
        strFileContent += "return " + strLuaClassN;

        //Create Script File
        FileStream fs = new FileStream(luapath, FileMode.Create);
        var utf8WithoutBom = new System.Text.UTF8Encoding(false);
        StreamWriter sw = new StreamWriter(fs, utf8WithoutBom);
        sw.Write(strFileContent);
        sw.Flush();
        sw.Close();
        return true;
    }

    static string LuaUIDefScriptPath
    {
        get
        {
            string n_scriptPath = Path.GetFullPath(Application.dataPath + "/ResourcesAssets/Lua/UIDef");
            if (!Directory.Exists(n_scriptPath))
                Directory.CreateDirectory(n_scriptPath);
            return n_scriptPath;
        }
    }

    [MenuItem("Project Tools/NGUI/Gen UI Widget Lua Binder", false, 10)]
    public static void GenUIWidgetLuaBinder()
    {
        GameObject obj = NGUIEditorTools.SelectedRoot(true);

        if (obj == null) return;

        //收集兴趣变量 n_打头
        string objName;
        string fieldName;
        string strSymbol = "n_";
        List<Transform> lstObjs = new List<Transform>();
        List<string> lstVarType = new List<string>();
        List<string> lstVarName = new List<string>();
        Transform[] tfs = obj.GetComponentsInChildren<Transform>(true);
        foreach (Transform tran in tfs)
        {
            objName = tran.name;
            fieldName = GetFieldType(tran.gameObject);
            if (objName.IndexOf(strSymbol) != 0)
            {
                if (tran != obj.transform) continue;
                if (string.IsNullOrEmpty(fieldName)) continue;
                objName = strSymbol + objName;
            }
            //if (string.IsNullOrEmpty(fieldName)) fieldName = "GameObject";
            lstObjs.Add(tran);
            lstVarType.Add(fieldName);
            if (lstVarName.Contains(objName))
            {
                Debug.LogError(string.Format("变量名重复 {0}", objName));
                return;
            }
            lstVarName.Add(objName);
        }

        string strFileContent = string.Empty;
        Transform trans = null;
        for (int i = 0; i < lstObjs.Count; i++)
        {
            trans = lstObjs[i];
            fieldName = lstVarType[i];
            objName = trans.name;
            if (trans == obj.transform)
            {
                if (string.IsNullOrEmpty(fieldName))
                {
                    strFileContent += "self." + objName + " = gameObject\n";
                }
                else
                {
                    strFileContent += "self." + objName + " = gameObject:GetComponent(\"" + fieldName + "\")\n";
                }
            }
            else
            {
                string objPath = trans.name;
                Transform transTemp = trans;
                while (transTemp.parent != null && transTemp.parent != obj.transform)
                {
                    transTemp = transTemp.parent;
                    objPath = transTemp.name + "/" + objPath;
                }
                if (string.IsNullOrEmpty(fieldName))
                {
                    strFileContent += "self." + objName + " = self:FindGameObject(\"" + objPath + "\")\n";
                }
                else
                {
                    strFileContent += "self." + objName + " = self:FindComponent(\"" + objPath + "\", \"" + fieldName + "\")\n";
                }
            }
        }

        Debug.Log(string.Format("UIWidgetLuaBinder:\n\n{0}", strFileContent));
    }
}
