using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;
using Newtonsoft.Json;
using System.IO;

public class LanguageValue
{
    public string key;
    public List<string> values;
}

public class LanguageEditor : EditorWindow
{
    // V5
    //Application.OpenURL("https://script.google.com/d/1zcsLSmq3Oddd8AsLuoKNDG1Y0eYBOHzyvGT7v94u1oN6igmsZb_PJzEm/newcopy");

    #region Variables
    WWW mConnection_WWW;
    Action<string, string> mConnection_Callback;
    string mConnection_Text = string.Empty;
    string mWebService_Status = string.Empty;
    int mWebService_Version = 5;

    //配置工具
    EditorToolsAsset mEditorToolsAsset = null;

    //google apps script
    string appsUrl = "https://script.google.com/macros/s/AKfycbwiV1dB_3JBcqQbKqXaa8MrtAsQY_KQVnwV3y6oo9SCsBrYjzY/exec";
    string scriptUrl = "https://script.google.com/d/1qyNd2peTV2lASwo0DGtOZxNRBUlZDJrpjzZRwYVlhZ-J-scAU_doc03J/edit";
    #endregion

    [MenuItem("Project Tools/LanguageEditor", false, 50)]
    private static void OpenAssetBundleWindow()
    {
        LanguageEditor lan = GetWindow<LanguageEditor>("LanguageEditor");
        lan.Show();
    }

    private void OnGUI()
    {
        OperateWebServiceGUI();
        OperateGoogleSpreadsheetGUI();
        OperateLanguageGUI();
    }

    #region 连接谷歌相关的操作
    private void OperateWebServiceGUI()
    {
        GUI.backgroundColor = Color.Lerp(Color.gray, Color.white, 0.5f);
        GUILayout.BeginVertical(EditorStyles.textArea, GUILayout.Height(1));

        //webservice网址
        EditorGUILayout.LabelField(scriptUrl, EditorStyles.label);
        GUILayout.BeginHorizontal();
        GUILayout.Space(5);
        if (GUILayout.Button("Go To (Read Only)", EditorStyles.toolbarButton, GUILayout.ExpandWidth(true)))
        {
            Application.OpenURL(scriptUrl);
        }
        GUILayout.Space(10);
        GUILayout.EndHorizontal();

        //apps srcipt网址
        EditorGUILayout.LabelField(appsUrl, EditorStyles.label);
        GUILayout.BeginHorizontal();
        GUILayout.Space(5);
        if (GUILayout.Button("Verify", EditorStyles.toolbarButton, GUILayout.ExpandWidth(true)))
        {
            ConnectWebService();
        }
        GUILayout.Space(10);
        GUILayout.EndHorizontal();

        //显示WebService状态
        OnGUI_GoogleWebServiceStatus();

        GUILayout.EndVertical();
    }
    #endregion

    #region 电子表格清单
    private List<SpreadsheetInfo> mSpreadsheetList = new List<SpreadsheetInfo>();
    private string[] m_SpreadsheetNames = new string[] { string.Empty };
    private string[] m_SpreadsheetIds = new string[] { string.Empty };
    private int m_index = -1;
    private string m_NewName = string.Empty;

    //操作谷歌电子表格
    void OperateGoogleSpreadsheetGUI()
    {
        GUILayout.Space(10);
        GUI.backgroundColor = Color.Lerp(Color.gray, Color.white, 0.5f);
        GUILayout.BeginVertical(EditorStyles.textArea, GUILayout.Height(1));
        GUILayout.Space(5);

        GUILayout.BeginHorizontal();
        GUILayout.Label("In Google Spreadsheet:", GUILayout.Width(140));
        m_index = EditorGUILayout.Popup(m_index, m_SpreadsheetNames, EditorStyles.toolbarPopup);
        if (GUILayout.Button("Refresh", EditorStyles.toolbarButton, GUILayout.ExpandWidth(false)))
        {
            //重新请求
            GetSpreadsheetList();
        }
        GUILayout.Space(10);
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUILayout.Label("Create New:", GUILayout.Width(100));
        m_NewName = GUILayout.TextField(m_NewName, EditorStyles.textField);
        GUILayout.Space(10);
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUI.enabled = !string.IsNullOrEmpty(m_NewName) && mConnection_WWW == null;
        if (GUILayout.Button("New", EditorStyles.toolbarButton, GUILayout.ExpandWidth(true)))
        {
            NewSpreadsheet(m_NewName);
            m_NewName = "";
        }
        GUI.enabled = m_SpreadsheetNames.Length > 0 && m_index != -1 && mConnection_WWW == null;
        if (GUILayout.Button("Open", EditorStyles.toolbarButton, GUILayout.ExpandWidth(true)))
        {
            OpenGoogleSpreadsheet(m_SpreadsheetIds[m_index]);
        }
        if (GUILayout.Button("Export To Lua", EditorStyles.toolbarButton, GUILayout.ExpandWidth(true)))
        {
            ExportSpreadsheetToLua(m_SpreadsheetIds[m_index]);
        }
        GUI.enabled = true;
        GUILayout.EndHorizontal();

        GUILayout.Space(5);
        GUILayout.EndVertical();
    }
    #endregion

    #region 支持语言
    private ReorderableList m_ReorderableList;

    //加载toolsconfig中的language
    private List<string> m_Languages = null;
    void OperateLanguageGUI()
    {
        GUILayout.Space(10);
        GUI.backgroundColor = Color.Lerp(Color.gray, Color.white, 0.5f);
        GUILayout.BeginVertical(EditorStyles.textArea, GUILayout.Height(1));
        GUILayout.Space(5);

        GUILayout.BeginHorizontal();
        GUILayout.Label("Use Languages:", GUILayout.Width(140));
        GUILayout.EndHorizontal();

        if (mEditorToolsAsset == null && m_Languages == null)
        {
            mEditorToolsAsset = AssetDatabase.LoadAssetAtPath("Assets/Scripts/Editor/EditorToolsAsset.asset", typeof(EditorToolsAsset)) as EditorToolsAsset;
            m_Languages = new List<string>();
            for (int i = 0; i < mEditorToolsAsset.languages.Length; ++i)
            {
                m_Languages.Add(mEditorToolsAsset.languages[i]);
            }
        }

        m_ReorderableList = new ReorderableList(m_Languages, m_Languages.GetType());
        m_ReorderableList.displayAdd = false;
        m_ReorderableList.displayRemove = false;
        m_ReorderableList.drawElementCallback = (rect, index, isActive, isFocused) =>
        {
            EditorGUI.TextField(rect, m_Languages[index]);
        };
        m_ReorderableList.drawHeaderCallback = (Rect rect) =>
        {
            GUI.Label(rect, "Load By EditorToolsAsset.asset (Read Only)");
        };
        m_ReorderableList.DoLayoutList();

        GUILayout.Space(5);
        GUILayout.EndVertical();
    }
    #endregion

    #region 私有函数
    //google apps srcpite 状态
    void OnGUI_GoogleWebServiceStatus()
    {
        if (mConnection_WWW != null)
        {
            int time = (int)((Time.realtimeSinceStartup % 3) * 2.5);
            string Loading = mConnection_Text + " ......".Substring(0, time);
            GUILayout.Space(4);
            GUILayout.BeginHorizontal();
            GUILayout.Label(Loading, GUILayout.Width(300));
            GUI.enabled = true;
            if (GUILayout.Button("Cancel", EditorStyles.toolbarButton, GUILayout.Width(80)))
                StopConnectionWWW();
            GUILayout.EndHorizontal();
            Repaint();
        }
        else
        {
            GUILayout.Space(4);
            GUILayout.BeginHorizontal();
            GUILayout.Label("", GUILayout.Width(300));
            GUI.enabled = false;
            if (GUILayout.Button("Cancel", EditorStyles.toolbarButton, GUILayout.Width(80)))
                StopConnectionWWW();
            GUILayout.EndHorizontal();
        }
        GUI.enabled = true;

        if (!string.IsNullOrEmpty(mWebService_Status))
        {
            Rect rect = new Rect(750, 40, 80, 15);
            if (mWebService_Status == "Online")
            {
                GUI.color = Color.green;
                GUI.Label(rect, new GUIContent("Online", "Online"), EditorStyles.label);
                GUI.color = Color.white;
            }
            else if (mWebService_Status == "Offline")
            {
                GUI.color = Color.red;
                GUI.Label(rect, new GUIContent("Offline", "Offline"), EditorStyles.label);
                GUI.color = Color.white;
            }
            else if (mWebService_Status == "UnsupportedVersion")
            {
                GUI.color = Color.red;
                GUI.Label(rect, new GUIContent("Error", "Error"), EditorStyles.label);
                GUI.color = Color.white;
            }
            else if (mWebService_Status == "Download Error")
            {
                GUI.color = Color.red;
                GUI.Label(rect, new GUIContent("Download Error", "Download Error"), EditorStyles.label);
                GUI.color = Color.white;
            }
        }
    }

    void ExportSpreadsheetToLua(string key)
    {
        StopConnectionWWW();
        string url = appsUrl + string.Format("?key={0}&action=GetLanguageSourceEx", key);
        mConnection_WWW = new WWW(url);
        mConnection_Callback = OnExportSpreadsheetToLua;
        EditorApplication.update += OnCheckForConnection;
        mConnection_Text = "Downloading spreadsheet";
    }

    void OnExportSpreadsheetToLua(string Result, string Error)
    {
        if (Result.Contains("Authorization is required to perform that action"))
        {
            mWebService_Status = "Download Error";
            return;
        }

        string[] ColumnSeparator = new string[] { "[*]" };
        string[] RowSeparator = new string[] { "[ln]" };

        string[] tempresult = Result.Split(RowSeparator, System.StringSplitOptions.None);
        if (tempresult.Length == 0)
        {
            mWebService_Status = "Download Error";
            return;
        }

        //获得语言类型
        List<string> languages = new List<string>();
        string[] temp1 = tempresult[0].Split(ColumnSeparator, System.StringSplitOptions.None);
        if (temp1.Length == 0)
        {
            mWebService_Status = "Download Error";
            return;
        }
        string spreadsheetName = temp1[0].Substring(4, temp1[0].Length - 4);
        //1是keys,所以不需要加入语言中
        for (int i = 2; i < temp1.Length; ++i)
        {
            languages.Add(temp1[i]);
        }

        //获取所有翻译的语言
        List<LanguageValue> values = new List<LanguageValue>();
        for (int i = 1; i < tempresult.Length; ++i)
        {
            LanguageValue tempvalue = new LanguageValue();
            string[] lines = tempresult[i].Split(ColumnSeparator, System.StringSplitOptions.None);
            if (lines.Length > 0)
            {
                tempvalue.key = lines[0];
                tempvalue.values = new List<string>();
                for (int j = 1; j < lines.Length; ++j)
                    tempvalue.values.Add(lines[j]);
            }
            values.Add(tempvalue);
        }
        CreateLanguageLuaScript(spreadsheetName, languages, values);

        AssetDatabase.Refresh();
    }

    void ConnectWebService()
    {
        StopConnectionWWW();
        mWebService_Status = null;
        mConnection_WWW = new WWW(appsUrl + "?action=Ping");
        mConnection_Callback = OnVerifyWebService;
        EditorApplication.update += OnCheckForConnection;
        mConnection_Text = "Verifying Web Service";
    }

    void OnVerifyWebService(string Result, string Error)
    {
        if (Result.Contains("Authorization is required to perform that action"))
        {
            Debug.Log("You need to authorize the webservice before using it. Check the steps 4 and 5 in the WebService Script");
            mWebService_Status = "Offline";
            return;
        }
        try
        {
            Hashtable data = JsonConvert.DeserializeObject<Hashtable>(Result);
            int version = int.Parse(data["script_version"].ToString());
            if (mWebService_Version == version)
            {
                mWebService_Status = "Online";

                //连接成功后,获取文档列表
                GetSpreadsheetList();
            }
            else
            {
                mWebService_Status = "UnsupportedVersion";
                Debug.LogError("The current Google WebService is not supported.\nPlease, delete the WebService from the Google Drive and Install the latest version.");
            }
        }
        catch (Exception)
        {
            Debug.LogError("Unable to access the WebService");
            mWebService_Status = "Offline";
        }
    }

    void GetSpreadsheetList()
    {
        StopConnectionWWW();
        mConnection_WWW = new WWW(appsUrl + "?action=GetSpreadsheetList");
        mConnection_Callback = OnGetSpreadsheetList;
        EditorApplication.update += OnCheckForConnection;
        mConnection_Text = "Get Spreadsheet List";
    }

    void OnGetSpreadsheetList(string Result, string Error)
    {
        if (Result.Contains("Authorization is required to perform that action"))
        {
            Debug.Log("You need to authorize the webservice before using it. Check the steps 4 and 5 in the WebService Script");
            return;
        }
        try
        {
            mSpreadsheetList.Clear();
            m_SpreadsheetNames = new string[] { string.Empty };
            m_SpreadsheetIds = new string[] { string.Empty };
            m_index = -1;

            Hashtable data = JsonConvert.DeserializeObject<Hashtable>(Result);
            if (data.Count > 0)
            {
                IDictionaryEnumerator myEnumerator = data.GetEnumerator();
                bool flag = myEnumerator.MoveNext();
                while (flag)
                {
                    SpreadsheetInfo temp = new SpreadsheetInfo();
                    temp.spreadsheetName = myEnumerator.Key.ToString();
                    temp.spreadsheetId = myEnumerator.Value.ToString();
                    mSpreadsheetList.Add(temp);
                    flag = myEnumerator.MoveNext();
                    m_index = 0;
                }
                m_SpreadsheetNames = GetSpreadsheetNames();
                m_SpreadsheetIds = GetSpreadsheetIds();
            }
        }
        catch (Exception)
        {
            Debug.LogError("Unable to get spreadsheet");
        }
    }

    void NewSpreadsheet(string spreadsheetname)
    {
        StopConnectionWWW();
        string query = appsUrl + "?action=NewSpreadsheet&name=" + spreadsheetname;
        mConnection_WWW = new WWW(query);
        mConnection_Callback = OnNewSpreadsheet;
        EditorApplication.update += OnCheckForConnection;
        mConnection_Text = "Creating Spreadsheet" + " (" + spreadsheetname + ")";
    }

    void OnNewSpreadsheet(string Result, string Error)
    {
        if (Result.Contains("Authorization is required to perform that action"))
        {
            Debug.Log("You need to authorize the webservice before using it. Check the steps 4 and 5 in the WebService Script");
            return;
        }
        try
        {
            Hashtable data = JsonConvert.DeserializeObject<Hashtable>(Result);
            if (data.Count > 0)
            {
                int version = int.Parse(data["script_version"].ToString());
                if (version == mWebService_Version)
                {
                    SpreadsheetInfo temp = new SpreadsheetInfo();
                    temp.spreadsheetName = data["name"].ToString();
                    temp.spreadsheetId = data["id"].ToString();
                    mSpreadsheetList.Add(temp);
                    m_SpreadsheetNames = GetSpreadsheetNames();
                    m_SpreadsheetIds = GetSpreadsheetIds();
                    m_index = mSpreadsheetList.Count - 1;
                    ReplaceSpreadsheep(temp.spreadsheetId);
                }
            }
        }
        catch (Exception)
        {
            Debug.LogError("Unable to get spreadsheet");
        }
    }

    void ReplaceSpreadsheep(string spreadsheetid)
    {
        StopConnectionWWW();
        WWWForm form = new WWWForm();
        form.AddField("key", spreadsheetid);
        form.AddField("action", "SetLanguageSource");
        string data = "Default<I2Loc>Key[*]Type[*]Desc[*]";
        if (mEditorToolsAsset != null && m_Languages != null)
        {
            for (int i = 0; i < m_Languages.Count; ++i)
            {
                if (i != m_Languages.Count - 1)
                    data += m_Languages[i] + "[*]";
                else
                    data += m_Languages[i] + "[ln]";
            }
        }
        form.AddField("data", data);
        form.AddField("updateMode", "Replace");
        mConnection_WWW = new WWW(appsUrl, form);
        mConnection_Callback = OnReplaceSpreadsheep;
        EditorApplication.update += OnCheckForConnection;
        mConnection_Text = "Upload Spreadsheet";
    }

    void OnReplaceSpreadsheep(string Result, string Error)
    {
        if (Result.Contains("Authorization is required to perform that action"))
        {
            Debug.Log("You need to authorize the webservice before using it. Check the steps 4 and 5 in the WebService Script");
            return;
        }
        try
        {
        }
        catch (Exception)
        {
            Debug.LogError("Unable to replace spreadsheet");
        }
    }

    void OpenGoogleSpreadsheet(string SpreadsheetKey)
    {
        //string SpreadsheetUrl = "https://docs.google.com/spreadsheet/ccc?key=" + SpreadsheetKey;
        string SpreadsheetUrl = "https://docs.google.com/spreadsheets/d/" + SpreadsheetKey + "/edit#gid=0";
        Application.OpenURL(SpreadsheetUrl);
    }

    void OnCheckForConnection()
    {
        if (mConnection_WWW != null && mConnection_WWW.isDone)
        {
            Action<string, string> callback = mConnection_Callback;
            string Result = string.Empty;
            string Error = mConnection_WWW.error;

            if (string.IsNullOrEmpty(Error))
            {
                Result = System.Text.Encoding.UTF8.GetString(mConnection_WWW.bytes);
            }

            StopConnectionWWW();
            if (callback != null)
                callback(Result, Error);
        }
    }

    void StopConnectionWWW()
    {
        EditorApplication.update -= OnCheckForConnection;
        mConnection_WWW = null;
        mConnection_Callback = null;
        mConnection_Text = string.Empty;
    }

    string[] GetSpreadsheetNames()
    {
        List<string> temp = new List<string>();
        for (int i = 0; i < mSpreadsheetList.Count; ++i)
        {
            temp.Add(mSpreadsheetList[i].spreadsheetName);
        }
        return temp.ToArray();
    }

    string[] GetSpreadsheetIds()
    {
        List<string> temp = new List<string>();
        for (int i = 0; i < mSpreadsheetList.Count; ++i)
        {
            temp.Add(mSpreadsheetList[i].spreadsheetId);
        }
        return temp.ToArray();
    }

    void CreateLanguageLuaScript(string name, List<string> languages, List<LanguageValue> languageList)
    {
        for (int i = 0; i < languages.Count; ++i)
        {
            string fileName = name + "_" + languages[i] + ".lua";
            string strFileContent = "local languageMap = {\n";

            for (int j = 0; j < languageList.Count; ++j)
            {
                string v = "";
                if (i < languageList[j].values.Count)
                    v = languageList[j].values[i];
                strFileContent += "    [" + '"' + languageList[j].key + '"' + "] = " + '"' + v + '"' + ',' + "\n";
            }

            strFileContent += "}\n";
            strFileContent += "return languageMap";

            string filePath = Application.dataPath + "/ResourcesAssets/Lua/Data/Language/" + fileName;
            FileStream fs = new FileStream(filePath, FileMode.Create);
            var utf8WithoutBom = new System.Text.UTF8Encoding(false);
            StreamWriter sw = new StreamWriter(fs, utf8WithoutBom);
            sw.Write(strFileContent);
            sw.Flush();
            sw.Close();
            fs.Close();
        }

        EditorUtility.DisplayDialog("完成", "生成完成", "确定");
    }
    #endregion
}