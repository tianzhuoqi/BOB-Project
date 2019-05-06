using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Reflection;

public class UIAtlasChannelChange
{
    public static string oldAltasTextureFolder = "/Art/Atlas/";
    public static string altasTexturePath = Application.dataPath + oldAltasTextureFolder;
    public static string newAltasTextureFolder = "/ResourcesAssets/AtlasData/";

    //[MenuItem("Project Tools/NGUI/Depart Atlas Channel（导出RGB和ALPHA图）", false, 10)]
    public static void AtlasTexturesRGBandAlphaChannel()
    {
        Debug.Log("start depart atlas data");

        string[] paths = Directory.GetFiles(altasTexturePath, "*.*", SearchOption.AllDirectories);
        foreach (string path in paths)
        {
            if (!string.IsNullOrEmpty(path) && IsTextureFile(path))   
            {
                SeperateRGBAandlphaChannel(path);
            }
        }

        Debug.Log("finish departing");
    }

    #region process texture

    static void SeperateRGBAandlphaChannel(string texPath)
    {
        string assetRelativePath = GetRelativeAssetPath(texPath);
        string newRelativePath = assetRelativePath.Replace(oldAltasTextureFolder, newAltasTextureFolder);

        string alphaTexRelativePath = GetRelativeAlphaAssetPath(texPath);
        string newAlphaTexRelativePath = alphaTexRelativePath.Replace(oldAltasTextureFolder, newAltasTextureFolder);

        Debug.Log("start rgb " + assetRelativePath);

        SetTextureReadableEx(assetRelativePath);

        Texture2D sourceTex = AssetDatabase.LoadAssetAtPath(assetRelativePath, typeof(Texture2D)) as Texture2D;
        if (!sourceTex)
        {
            Debug.LogError("Load Texture Failed : " + assetRelativePath);
            return;
        }

        //same with the texture import setting
        bool bGenerateMipMap = false;
        Texture2D rgbTex = new Texture2D(sourceTex.width, sourceTex.height, TextureFormat.RGB24, bGenerateMipMap);
        rgbTex.SetPixels(sourceTex.GetPixels());
        rgbTex.Apply();

        var colors2rdLevel = sourceTex.GetPixels();
        Color[] colorsAlpha = new Color[colors2rdLevel.Length];
        if (colors2rdLevel.Length != sourceTex.width * sourceTex.height)
        {
            Debug.LogError("Size Error.");
            return;
        }

        for (int i = 0; i < colors2rdLevel.Length; ++i)
        {
            colorsAlpha[i].r = colors2rdLevel[i].a;
            colorsAlpha[i].g = colors2rdLevel[i].a;
            colorsAlpha[i].b = colors2rdLevel[i].a;
        }

        Texture2D alphaTex = null;
        alphaTex = new Texture2D(sourceTex.width, sourceTex.height, TextureFormat.RGB24, bGenerateMipMap);
        alphaTex.SetPixels(colorsAlpha);
        alphaTex.Apply();

        byte[] bytes = rgbTex.EncodeToPNG();
        File.WriteAllBytes(newRelativePath, bytes);

        byte[] alphabytes = null;
        alphabytes = alphaTex.EncodeToPNG();             
        File.WriteAllBytes(newAlphaTexRelativePath, alphabytes);

        ReImportAsset(newRelativePath, sourceTex.width, sourceTex.height);
        ReImportAsset(newAlphaTexRelativePath, sourceTex.width, sourceTex.height);

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Debug.Log("Succeed Departing : " + assetRelativePath);
    }

    static void ReImportAsset(string path, int width, int height)
    {
        try
        { 
            AssetDatabase.ImportAsset(path);
        }
        catch
        {
            Debug.LogError("Import Texture failed: " + path);
            return;
        }

        TextureImporter importer = null;
        try
        {
            importer = (TextureImporter)TextureImporter.GetAtPath(path);
        }
        catch
        {
            Debug.LogError("Load Texture failed: " + path);
            return;
        }
        if (importer == null)
        {
            return;
        }

        //统一修改格式
        importer.maxTextureSize = Mathf.Max(width, height);
        importer.textureType = TextureImporterType.Default;
        importer.wrapMode = TextureWrapMode.Clamp;
        importer.filterMode = FilterMode.Bilinear;
        importer.mipmapEnabled = false;
        importer.textureCompression = TextureImporterCompression.CompressedLQ;
        importer.isReadable = false;
        importer.alphaIsTransparency = false;

        AssetDatabase.ImportAsset(path);
    }

    //set readable flag and set textureFormat RGBA32  
    static void SetTextureReadableEx(string _relativeAssetPath)
    {
        TextureImporter ti = null;
        try
        {
            ti = (TextureImporter)TextureImporter.GetAtPath(_relativeAssetPath);
        }
        catch
        {
            Debug.LogError("Load Texture failed: " + _relativeAssetPath);
            return;
        }
        if (ti == null)
        {
            return;
        }
        //this is essential for departing Textures for ETC1. No compression format for following operation.
        ti.textureType = TextureImporterType.Default;
        ti.wrapMode = TextureWrapMode.Clamp;
        ti.filterMode = FilterMode.Trilinear;
        ti.mipmapEnabled = false;
        ti.isReadable = true;
        ti.textureCompression = TextureImporterCompression.Uncompressed;  
        AssetDatabase.ImportAsset(_relativeAssetPath);

        AssetDatabase.Refresh();
        AssetDatabase.SaveAssets();
    }

    #endregion

    #region string or path helper

    static bool IsTextureFile(string _path)
    {
        string path = _path.ToLower();
        return path.EndsWith(".psd") || path.EndsWith(".tga") || path.EndsWith(".png") || path.EndsWith(".jpg") || path.EndsWith(".bmp") || path.EndsWith(".tif") || path.EndsWith(".gif");
    }

    static bool IsTextureConverted(string _path)
    {
        return _path.Contains("_RGB.") || _path.Contains("_Alpha.");
    }

    static string GetRelativeAlphaAssetPath(string _texPath)
    {
        string filename = System.IO.Path.GetFileNameWithoutExtension(_texPath);
        string filename2 = filename + "_Alpha";
        _texPath = _texPath.Replace(filename, filename2);
        return GetRelativeAssetPath(_texPath);
    }

    static string GetRelativeAssetPath(string _fullPath)
    {
        _fullPath = GetRightFormatPath(_fullPath);
        int idx = _fullPath.IndexOf("Assets");
        string assetRelativePath = _fullPath.Substring(idx);
        return assetRelativePath;
    }

    static string GetRightFormatPath(string _path)
    {
        return _path.Replace("\\", "/");
    }

    #endregion
}