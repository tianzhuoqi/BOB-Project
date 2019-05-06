using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using com.nkm.common.proto.client;

public class BundleDataInfo
{
    public string m_sGuid;
    public string m_sAssetBundlePath;
    public string m_sVersion;
    public string m_sName;
    public string m_sExtension;
    public BundleDataInfo(string guid, string path, string version, string name, string extension)
    {
        m_sGuid = guid;
        m_sAssetBundlePath = path;
        m_sVersion = version;
        m_sName = name;
        m_sExtension = extension;
    }
}

public class AssetBundleBuild : Editor {

    static string resourceOtherPath = Application.dataPath + @"/ResourcesAssets";
    static int assetsBundleVersion = 0;
    static string resourceOutPutPath = Application.dataPath + @"/StreamingAssets";
    static string LuaBasePath = Application.dataPath + @"/Framework_ToLua_NGUI/ToLua/Lua";
    static Dictionary<string, int> m_pAssetBundleReferenceCountDic = new Dictionary<string, int>();
    static Dictionary<string, string> m_pAssetBundleGuidByPathDic = new Dictionary<string, string>();
    static string m_version = string.Empty;
    static string Version
    {
        get
        {
            if (string.IsNullOrEmpty(m_version))
            {
                var infoAssets = Resources.Load("info") as TextAsset;
                m_version = infoAssets.text;
            }
            return m_version;
        }
    }

    static Dictionary<string, BundleDataInfo> m_pBundleDataInfoDict = new Dictionary<string, BundleDataInfo>();

    [MenuItem("Project Tools/Build Tools/Build Windows AssetBundle", false, 30)]
    public static void BuildWindowsAssetBundle()
    {
        m_pBundleDataInfoDict.Clear();
        m_pAssetBundleReferenceCountDic.Clear();
        m_pAssetBundleGuidByPathDic.Clear();
        Hashtable bundle = new Hashtable();
        GetDirectory(resourceOtherPath, ref bundle);
        
        BuildAssetBundle(BuildTarget.StandaloneWindows64);
    }

    [MenuItem("Project Tools/Build Tools/Build IOS AssetBundle", false, 30)]
    public static void BuildIOSAssetBundle()
    {
        m_pBundleDataInfoDict.Clear();
        m_pAssetBundleReferenceCountDic.Clear();
        m_pAssetBundleGuidByPathDic.Clear();
        Hashtable bundle = new Hashtable();
        GetDirectory(resourceOtherPath, ref bundle);

        BuildAssetBundle(BuildTarget.iOS);
    }

    [MenuItem("Project Tools/Build Tools/Build Android AssetBundle", false, 30)]
    public static void BuildAndroidAssetBundle()
    {
        m_pBundleDataInfoDict.Clear();
        m_pAssetBundleReferenceCountDic.Clear();
        m_pAssetBundleGuidByPathDic.Clear();
        Hashtable bundle = new Hashtable();
        GetDirectory(resourceOtherPath, ref bundle);

        BuildAssetBundle(BuildTarget.Android);
    }

    [MenuItem("Project Tools/Build Tools/Clear AssetBundleName", false, 30)]
    public static void ClearAssetBundleName()
    {
        var AssetBundleNames = AssetDatabase.GetAllAssetBundleNames();
        for (int i = 0; i < AssetBundleNames.Length; i++)
            AssetDatabase.RemoveAssetBundleName(AssetBundleNames[i], true);

        AssetDatabase.Refresh();
    }

    private static void SetAssetBundleInfo(string abPath)
    {
        string guid = AssetDatabase.AssetPathToGUID(abPath);
        if (!m_pAssetBundleReferenceCountDic.ContainsKey(guid))
        {
            m_pAssetBundleReferenceCountDic.Add(guid, 1);
        }
        else
        {
            m_pAssetBundleReferenceCountDic[guid]++;
        }
        if (!m_pAssetBundleGuidByPathDic.ContainsKey(guid))
            m_pAssetBundleGuidByPathDic.Add(guid, abPath);
    }

    private static void GetDirectory(string path, ref Hashtable bundle)
    {
        DirectoryInfo folder = new DirectoryInfo(path);
        if (folder != null)
        {
            foreach (var directory in folder.GetDirectories())
            {
                GetDirectory(directory.FullName, ref bundle);
            }

            foreach (var file in folder.GetFileSystemInfos())
            {
                if (!(file is DirectoryInfo)
                    && !file.Name.EndsWith(".meta")
                    && !file.Name.EndsWith(".lua")
                    && file.Name != ".DS_Store"
                    && !file.Name.EndsWith(".json")
                    && !file.Name.EndsWith(".cs"))
                {
#if UNITY_EDITOR_WIN
                    // 这里是主资源 必须要打包的
                    string abPath = @"Assets" + file.FullName.Replace(Application.dataPath.Replace("/", "\\"), "").Replace("\\", "/");
#else
                    // 这里是主资源 必须要打包的
                    string abPath = @"Assets" + file.FullName.Replace(Application.dataPath, "");
#endif
                    string strGuid = AssetDatabase.AssetPathToGUID(abPath);
                    AssetImporter ab = AssetImporter.GetAtPath(abPath);

                    ab.assetBundleName = strGuid;
                    if (!m_pBundleDataInfoDict.ContainsKey(ab.assetBundleName))
                    {
                        BundleDataInfo myDataInfo = new BundleDataInfo(ab.assetBundleName, abPath, Version, file.Name.Substring(0, file.Name.LastIndexOf('.')), file.Extension.Replace(".", ""));
                        m_pBundleDataInfoDict.Add(ab.assetBundleName, myDataInfo);
                    }
                    string[] dps = AssetDatabase.GetDependencies(abPath);
                    for (int i = 0; i < dps.Length; i++)
                    {
                        if (!dps[i].Equals(abPath) && !dps[i].EndsWith(".cs"))
                            SetAssetBundleInfo(dps[i]);
                    }
                }
            }
        }
    }

    private static void BuildAssetBundle(BuildTarget target)
    {
        // 打包lua
        ToLuaMenu.BuildNotJitBundles();

        // 引用计算大于1的资源需要设置assetBundleName 进行打包
        foreach (var md5 in m_pAssetBundleReferenceCountDic)
        {
            if (md5.Value > 1)
            {
                AssetImporter ab = AssetImporter.GetAtPath(m_pAssetBundleGuidByPathDic[md5.Key]);
                ab.assetBundleName = md5.Key;
                string[] resources = ab.assetPath.Split('.');
                if (!m_pBundleDataInfoDict.ContainsKey(md5.Key))
                {
                    BundleDataInfo myDataInfo = new BundleDataInfo(md5.Key, m_pAssetBundleGuidByPathDic[md5.Key], Version, resources[0].Remove(0, resources[0].LastIndexOf('/') + 1), resources[1]);
                    m_pBundleDataInfoDict.Add(md5.Key, myDataInfo);
                }
            }
        }

        AssetDatabase.RemoveUnusedAssetBundleNames();

        BuildAssetBundleOptions options = BuildAssetBundleOptions.ChunkBasedCompression | BuildAssetBundleOptions.DeterministicAssetBundle;

        string outPutPath = "";

        if (target == BuildTarget.Android)
        {
            outPutPath = resourceOutPutPath + "/Android/" + Version;
        }
        else if(target == BuildTarget.iOS)
        {
            outPutPath = resourceOutPutPath + "/iOS/" + Version;
        }
        else
        {
            outPutPath = resourceOutPutPath + "/Windows/" + Version;
        }

        if (!Directory.Exists(outPutPath))
        {
            Directory.CreateDirectory(outPutPath);
        }

        BuildPipeline.BuildAssetBundles(outPutPath, options, target);

        BuildBundleInfoProtoFile(outPutPath);

        //DeleteManifestFile(outPutPath);

        AssetDatabase.Refresh();

        Debug.Log("BuildAssetBundle over");
    }

    private static void DeleteManifestFile(string path)
    {
        DirectoryInfo folder = new DirectoryInfo(path);
        {
            if (folder != null)
            {
                foreach (var file in folder.GetFileSystemInfos())
                {
                    if (file.Name.Contains(".manifest"))
                    {
                        File.Delete(file.FullName);       
                    }
                }
            }
        }
    }

    private static void BuildBundleInfoProtoFile(string outPutPath)
    {
        string path = outPutPath + @"/assetsBundleInfos.data";
        if (File.Exists(path))
            File.Delete(path);

        BundleInfoTable.Builder bundleInfoTable = BundleInfoTable.CreateBuilder();

        BundleInfo.Builder bundleInfoManifest = BundleInfo.CreateBuilder();
        bundleInfoManifest.SetGuid(Version);
        bundleInfoManifest.SetPath(Version);
        bundleInfoManifest.SetMd5(NUtil.md5file(outPutPath + "/" + Version));
        bundleInfoTable.AddData(bundleInfoManifest.Build());

        if (m_pBundleDataInfoDict.Count > 0)
        {
            foreach (KeyValuePair<string, BundleDataInfo> kvp in m_pBundleDataInfoDict)
            {
                BundleInfo.Builder bundleInfo = BundleInfo.CreateBuilder();
                bundleInfo.SetGuid(kvp.Value.m_sGuid);
                bundleInfo.SetPath(kvp.Value.m_sAssetBundlePath.Replace("Assets/ResourcesAssets/", ""));
                bundleInfo.SetMd5(NUtil.md5file(outPutPath + "/" + kvp.Value.m_sGuid));
                bundleInfoTable.AddData(bundleInfo.Build());
            }
        }
        var AssetBundleNames = AssetDatabase.GetAllAssetBundleNames();
        for (int i = 0; i < AssetBundleNames.Length; i++)
        {
            if (AssetBundleNames[i].Contains("lua"))
            {
                BundleInfo.Builder bundleInfo = BundleInfo.CreateBuilder();
                bundleInfo.SetGuid(AssetBundleNames[i]);
                bundleInfo.SetPath(AssetBundleNames[i]);
                bundleInfo.SetMd5(NUtil.md5file(outPutPath + "/" + AssetBundleNames[i]));
                bundleInfoTable.AddData(bundleInfo.Build());
            }
        }

        FileStream fs = new FileStream(path, FileMode.CreateNew);
        var bytes = bundleInfoTable.Build().ToByteArray();
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();
    }


    private static void BuildLuaFile(string outPutPath)
    {
        string path = outPutPath + @"/assetbundledatatable.lua";
        if (File.Exists(path))
            File.Delete(path);
        FileStream fs = new FileStream(path, FileMode.CreateNew);
        fs.Close();
        StreamWriter sw = new StreamWriter(path, true);
        sw.Write("local assetbundledatatable = \n{");

        if (m_pBundleDataInfoDict.Count > 0)
        {
            sw.Write("\n");
            foreach (KeyValuePair<string, BundleDataInfo> kvp in m_pBundleDataInfoDict)
            {
                sw.Write("    ['" + kvp.Value.m_sAssetBundlePath + "'] =\n    {\n        Guid = '" + kvp.Value.m_sGuid + "',\n");
                sw.Write("        AssetBundlePath = '" + kvp.Value.m_sAssetBundlePath + "',\n");
                sw.Write("        Name = '" + kvp.Value.m_sName + "',\n");
                sw.Write("        Extension = '" + kvp.Value.m_sExtension + "',\n");
                sw.Write("        Version = '" + kvp.Value.m_sVersion + "',\n");
                sw.Write("    },\n\n");
            }
        }

        sw.Write("    ['BundleFileInfos'] = \n    {\n");
        sw.Write("        ['" + Version + "'] = {'" + NUtil.md5file(outPutPath + "/" + Version) + "'},\n");
        var AssetBundleNames = AssetDatabase.GetAllAssetBundleNames();
        for (int i = 0; i < AssetBundleNames.Length; i++)
        {
            sw.Write("        ['" + AssetBundleNames[i] + "'] = {'" + NUtil.md5file(outPutPath + "/" + AssetBundleNames[i]) + "'},\n");
        }
        sw.Write("    },\n\n");

        sw.Write("}\nreturn assetbundledatatable\n");
        sw.Close();
    }
}
