using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Reflection;

public class UIAtlasCleanMaterial
{
    //[MenuItem("Project Tools/NGUI/Clean Material（清理图集材质球）", false, 10)]
    public static void CleanMaterial()
    {
        Debug.Log("clean material");

        string[] paths = Directory.GetFiles(UIAtlasChannelChange.altasTexturePath, "*.*", SearchOption.AllDirectories);
        foreach (string path in paths)
        {
            if (!string.IsNullOrEmpty(path) && IsAtlasPrefabFile(path))
            {
                string str = "Assets" + path.Replace(Application.dataPath, "");
                GameObject atlasObj = AssetDatabase.LoadAssetAtPath(str, typeof(GameObject)) as GameObject;
                UIAtlas atlas = atlasObj.GetComponent<UIAtlas>();
                atlas.spriteMaterial = null;
                atlas.spriteList.Clear();
            }
        }

        Debug.Log("clean save");
    }

    #region string or path helper

    static bool IsAtlasPrefabFile(string _path)
    {
        string path = _path.ToLower();
        return path.EndsWith(".prefab");
    }

    #endregion
}
