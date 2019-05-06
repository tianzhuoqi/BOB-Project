using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NTabs : MonoBehaviour
{
    public int tabCount = 1;            //Tab标签个数
    public int spacing = 0;             //Tab标签间距

    [ContextMenu("CloneTab")]
    public void CloneTab()
    {
        List<Transform> list = GetChildList();
        if (list.Count == 0)
        {
            Debug.LogError("没有Tab子项");
            return;
        }

        Transform fist = list[0];
        for (int i = 0; i < tabCount; i++)
        {
            GameObject go;
            if (i < list.Count)
            {
                go = list[i].gameObject;
            }
            else
            {
                go = Instantiate(fist.gameObject) as GameObject;
                go.transform.parent = transform;
                go.transform.localPosition = fist.localPosition + new Vector3(i * spacing, 0, 0);
                go.transform.localScale = fist.localScale;
            }
            go.name = "Tab" + i;
        }
    }

    public List<Transform> GetChildList()
    {
        Transform myTrans = transform;
        List<Transform> list = new List<Transform>();

        for (int i = 0; i < myTrans.childCount; ++i)
        {
            Transform t = myTrans.GetChild(i);
            if (t && t.gameObject.activeSelf)
                list.Add(t);
        }

        return list;
    }
}
