using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Reflection;

public class UIAtlasExportJson
{
    //[MenuItem("Project Tools/NGUI/Save Atlas Json Data（导出JSON配置文件）", false, 10)]
    public static void SaveAtlasJsonData()
    {
        Debug.Log("save atlas json data");

        string[] paths = Directory.GetFiles(UIAtlasChannelChange.altasTexturePath, "*.*", SearchOption.AllDirectories);
        foreach (string path in paths)
        {
            if (!string.IsNullOrEmpty(path) && IsAtlasPrefabFile(path))
            {
                string str = "Assets" + path.Replace(Application.dataPath, "");
                GameObject atlasObj = AssetDatabase.LoadAssetAtPath(str, typeof(GameObject)) as GameObject;
                UIAtlas atlas = atlasObj.GetComponent<UIAtlas>();
                SaveAtlasJsonData(atlas);
            }
        }

        Debug.Log("finish save");
    }

    #region process data
    
    static void SaveAtlasJsonData(UIAtlas atlas)
    {
        if (atlas == null) return;

        Hashtable frames = new Hashtable();
        foreach (UISpriteData data in atlas.spriteList)
        {
            Hashtable item = new Hashtable();

            Hashtable frame = new Hashtable();
            int frameX = data.x;
            int frameY = data.y;
            int frameW = data.width;
            int frameH = data.height;
            frame.Add("x", frameX);
            frame.Add("y", frameY);
            frame.Add("w", frameW);
            frame.Add("h", frameH);

            frame.Add("bl", data.borderLeft);
            frame.Add("br", data.borderRight);
            frame.Add("bb", data.borderBottom);
            frame.Add("bt", data.borderTop);

            Hashtable spriteSize = new Hashtable();
            Hashtable sourceSize = new Hashtable();
            if (frameW > 0)
            {
                int spriteX = data.paddingLeft;
                spriteSize.Add("x", spriteX);

                int spriteW = 0;
                spriteSize.Add("w", spriteW);

                int sourceW = data.paddingRight + (spriteX + spriteW);
                sourceSize.Add("w", sourceW);
            }
            if (frameH > 0)
            {
                int spriteY = data.paddingTop;
                spriteSize.Add("y", spriteY);

                int spriteH = 0;
                spriteSize.Add("h", spriteH);

                sourceSize.Add("h", spriteH);
            }
            item.Add("sourceSize", sourceSize);
            item.Add("spriteSourceSize", spriteSize);
            item.Add("frame", frame);

            frames.Add(data.name, item);
        }
        Hashtable encodedHash = new Hashtable();
        encodedHash.Add("frames", frames);

        string path = Application.dataPath + UIAtlasChannelChange.newAltasTextureFolder + atlas.name + "Data.bytes";
        FileStream fs = new FileStream(path, FileMode.Create, FileAccess.Write);
        StreamWriter sw = new StreamWriter(fs, System.Text.Encoding.UTF8);
        string jsonString = NGUIJson.jsonEncode(encodedHash);

        sw.WriteLine(jsonString);
        sw.Close();
        fs.Close();

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
    
    #endregion

    #region string or path helper

    static bool IsAtlasPrefabFile(string _path)
    {
        string path = _path.ToLower();
        return path.EndsWith(".prefab");
    }

    #endregion
}
