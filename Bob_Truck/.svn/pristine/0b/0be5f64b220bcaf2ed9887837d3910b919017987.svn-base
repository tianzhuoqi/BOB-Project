using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class UITextureFormat
{
    private static string filePath = Application.dataPath + "/Scripts/Editor/NGUITool/TextureFormat.csv";

    [MenuItem("Project Tools/NGUI/TextureFormat（读表批处理格式）")]
    public static void InitModel()
    {
        ///修改压缩格式
        Debug.Log("******************************** Change Texture's Importer ********************************");

        using (StreamReader sr = new StreamReader(filePath, System.Text.Encoding.Default))
        {
            //过滤掉标题行
            sr.ReadLine();

            string line = null;
            int lineNum = 1;
            while ((line = sr.ReadLine()) != null && line != "")
            {
                string[] content = line.Split(',');
                if (content.Length != 5)
                {
                    Debug.LogError("Texture format configuration is wrong in line " + lineNum);
                }
                bool issave = false;
                if (content[3] == "1")
                    issave = true;

                string path = System.IO.Path.Combine(Application.dataPath, content[1]);
                //若为路径，则将此路径下所有图片替换为指定格式
                if (System.IO.Directory.Exists(path))
                {
                    SetTexturesByPath(path, issave);
                }
                else if (System.IO.File.Exists(path))
                {
                    SetTexture(path);
                }
                else
                {
                    Debug.LogError("Texture format configuration is wrong in line " + lineNum + ", Can't find Path " + content[1]);
                }

                //多国语言修改
                if (content[4] != "0")
                {
                    string[] language = content[6].Split(';');
                    for (int i = 0; i < language.Length; ++i)
                    {
                        if (language[i] == "")
                            continue;
                        string newpath = content[1].Replace("Resources/Language/Chinese", string.Format("Language/{0}", language[i]));
                        path = System.IO.Path.Combine(Application.dataPath, newpath);
                        if (System.IO.Directory.Exists(path))
                        {
                            SetTexturesByPath(path, issave);
                        }
                        else if (System.IO.File.Exists(path))
                        {
                            SetTexture(path);
                        }
                        else
                        {
                            Debug.LogError("Texture format configuration is wrong in line " + lineNum + ", Can't find Path " + content[1]);
                        }
                    }
                }
                ++lineNum;
            }
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Debug.Log("******************************** Change Texture's Importer Finish ********************************");
    }

    private static void SetTexturesByPath(string path, bool saveformat)
    {
        foreach (string sFile in System.IO.Directory.GetFiles(path))
        {
            string sPath = "Assets" + sFile.Replace(Application.dataPath, "");
            TextureImporter textureImporter = AssetImporter.GetAtPath(sPath) as TextureImporter;
            if (textureImporter == null)
            {
                continue;
            }

            bool ischange = false;
            if (textureImporter.textureType != TextureImporterType.Default)
            {
                ischange = true;
                textureImporter.textureType = TextureImporterType.Default;
            }
            if (textureImporter.sRGBTexture != false && !saveformat)
            {
                ischange = true;
                textureImporter.sRGBTexture = false;
            }
            if (textureImporter.mipmapEnabled != false && !saveformat)
            {
                ischange = true;
                textureImporter.mipmapEnabled = false;
            }
            if (textureImporter.wrapMode != TextureWrapMode.Clamp && !saveformat)
            {
                ischange = true;
                textureImporter.wrapMode = TextureWrapMode.Clamp;
            }
            if (textureImporter.filterMode != FilterMode.Bilinear && !saveformat)
            {
                ischange = true;
                textureImporter.filterMode = FilterMode.Bilinear;
            }
            if (textureImporter.textureCompression != TextureImporterCompression.CompressedHQ)
            {
                ischange = true;
                textureImporter.textureCompression = TextureImporterCompression.CompressedHQ;
            }

            if (ischange)
                AssetDatabase.ImportAsset(sPath);
        }
    }

    private static void SetTexture(string path)
    {
        string sPath = "Assets" + path.Replace(Application.dataPath, "");
        TextureImporter textureImporter = AssetImporter.GetAtPath(sPath) as TextureImporter;
        textureImporter.textureType = TextureImporterType.Default;
        textureImporter.mipmapEnabled = false;
        textureImporter.wrapMode = TextureWrapMode.Clamp;
        textureImporter.filterMode = FilterMode.Bilinear;
        textureImporter.textureCompression = TextureImporterCompression.CompressedHQ;
        AssetDatabase.ImportAsset(sPath);
    }
}
