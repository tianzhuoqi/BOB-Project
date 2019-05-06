using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;

#pragma warning disable 0618

public class TextureChangeModel
{
    public string path;
    public TextureImporterFormat format = TextureImporterFormat.PVRTC_RGB2;

    public TextureChangeModel(string p, TextureImporterFormat tf)
    {
        path = p;
        format = tf;
    }
}

public class UIOldTextureFormat
{
    private static string filePath = Application.dataPath + "/Scripts/Editor/NGUITool/OldTextureFormat.csv";

    //[MenuItem("Project Tools/NGUI/Texture Format（批处理格式）/IOS", false, 10)]
    public static void EditInitModelIphone()
    {
        InitModel(BuildTargetGroup.iOS);
    }

    //[MenuItem("Project Tools/NGUI/Texture Format（批处理格式）/Android", false, 10)]
    public static void EditInitModelAndroid()
    {
        InitModel(BuildTargetGroup.Android);
    }

    private static void InitModel(BuildTargetGroup group)
    {
        ///修改压缩格式
        Debug.Log("******************************** Change Texture's Importer ********************************");

        //CSV配置文件中的字符串对应的Unity Texture格式
        Dictionary<string, TextureImporterFormat> strToTextureFormat = new Dictionary<string, TextureImporterFormat>();
        strToTextureFormat.Add("ARGB32", TextureImporterFormat.ARGB32);
        strToTextureFormat.Add("RGBA32", TextureImporterFormat.RGBA32);
        strToTextureFormat.Add("RGBA16", TextureImporterFormat.RGBA16);
        strToTextureFormat.Add("RGB16", TextureImporterFormat.RGB16);
        strToTextureFormat.Add("RGB24", TextureImporterFormat.RGB24);
        strToTextureFormat.Add("ETC_RGB4", TextureImporterFormat.ETC_RGB4);
        strToTextureFormat.Add("PVRTC_RGBA4", TextureImporterFormat.PVRTC_RGBA4);
        strToTextureFormat.Add("PVRTC_RGB4", TextureImporterFormat.PVRTC_RGB4);

        //不同平台在CSV文件中对应的列号
        int formatColumnIndex = 0;
        if (group == BuildTargetGroup.Android)
        {
            formatColumnIndex = 3;
        }
        else if (group == BuildTargetGroup.iOS)
        {
            formatColumnIndex = 4;
        }

        using (StreamReader sr = new StreamReader(filePath, System.Text.Encoding.Default))
        {
            //过滤掉标题行
            sr.ReadLine();

            string line = null;
            int lineNum = 1;
            while ((line = sr.ReadLine()) != null && line != "")
            {
                string[] content = line.Split(',');
                if (content.Length != 7)
                {
                    Debug.LogError("Texture format configuration is wrong in line " + lineNum);
                }
                string path = System.IO.Path.Combine(Application.dataPath, content[1]);
                TextureImporterFormat format = strToTextureFormat[content[formatColumnIndex]];

                bool issave = false;
                if (content[5] == "1")
                    issave = true;

                //若为路径，则将此路径下所有图片替换为指定格式
                if (System.IO.Directory.Exists(path))
                {
                    SetTexturesByPath(new TextureChangeModel(path, format), issave);
                }
                else if (System.IO.File.Exists(path))
                {
                    SetTexture(new TextureChangeModel(path, format));
                }
                else
                {
                    Debug.LogError("Texture format configuration is wrong in line " + lineNum + ", Can't find Path " + content[1]);
                }
                //多国语言修改
                if (content[6] != "0")
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
                            SetTexturesByPath(new TextureChangeModel(path, format), issave);
                        }
                        else if (System.IO.File.Exists(path))
                        {
                            SetTexture(new TextureChangeModel(path, format));
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

    private static void SetTexturesByPath(TextureChangeModel model, bool saveformat)
    {
        foreach (string sFile in System.IO.Directory.GetFiles(model.path))
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
            if (textureImporter.textureFormat != model.format)
            {
                ischange = true;
                textureImporter.textureFormat = model.format;
            }
            if (textureImporter.textureCompression != TextureImporterCompression.CompressedHQ)
            {
                ischange = true;
                textureImporter.textureCompression = TextureImporterCompression.CompressedHQ;
            }
            if (model.format == TextureImporterFormat.PVRTC_RGBA4 || model.format == TextureImporterFormat.PVRTC_RGB4)
            {
                if (textureImporter.compressionQuality != 100)
                {
                    textureImporter.compressionQuality = 100;
                    ischange = true;
                }
            }

            if (model.format == TextureImporterFormat.PVRTC_RGBA4 ||
                model.format == TextureImporterFormat.RGBA16 || model.format == TextureImporterFormat.ARGB16 ||
                model.format == TextureImporterFormat.RGBA32 || model.format == TextureImporterFormat.ARGB32)
            {
                if (textureImporter.alphaIsTransparency == false)
                {
                    textureImporter.alphaIsTransparency = true;
                    ischange = true;
                }
            }
            else if (model.format == TextureImporterFormat.PVRTC_RGB4 || model.format == TextureImporterFormat.ETC_RGB4 ||
                model.format == TextureImporterFormat.RGB16 || model.format == TextureImporterFormat.RGB24)
            {
                if (textureImporter.alphaIsTransparency == true)
                {
                    textureImporter.alphaIsTransparency = false;
                    ischange = true;
                }
            }

            if (ischange)
                AssetDatabase.ImportAsset(sPath);
        }
    }

    private static void SetTexture(TextureChangeModel model)
    {
        string sPath = "Assets" + model.path.Replace(Application.dataPath, "");
        TextureImporter textureImporter = AssetImporter.GetAtPath(sPath) as TextureImporter;
        textureImporter.textureType = TextureImporterType.Default;
        textureImporter.mipmapEnabled = false;
        textureImporter.wrapMode = TextureWrapMode.Clamp;
        textureImporter.filterMode = FilterMode.Bilinear;
        textureImporter.textureCompression = TextureImporterCompression.CompressedHQ;
        textureImporter.textureFormat = model.format;
        AssetDatabase.ImportAsset(sPath);
    }
}
