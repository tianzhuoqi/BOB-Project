using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NTabView : MonoBehaviour
{
    [NoToLua]
    public int m_tabCount = 1;                  //Tab标签个数
    [NoToLua]
    public GameObject m_tabsObj;                //Tabs对象  
    [NoToLua]
    public GameObject m_viewObj;                //View对象
    [NoToLua]
    public bool m_useCommonTemplate = true;     //使用共同模板
    [NoToLua]
    public int m_currentIndex = 0;              //当前显示的Tab(默认值0)
    [NoToLua]
    public List<Transform> m_tabs;              //tab按键集合
    [NoToLua]
    public List<NLuaTabItemWidget> m_tabItems;  //tab视图集合

#if UNITY_EDITOR
    [NoToLua]
    [Header("按钮间距")]
    public int m_spacing = 140;                  //Tab标签间距

    [NoToLua][ContextMenu("InitTabView")]
    public void InitTabView()
    {
        List<Transform> tabs = GetTabList();
        if (tabs.Count == 0)
        {
            Debug.LogError("没有Tab子项，至少需要手动添加一个");
            return;
        }

        Transform fistTab = tabs[0];
        for (int i = 0; i < m_tabCount; i++)
        {
            GameObject go;
            if (i < tabs.Count)
            {
                go = tabs[i].gameObject;
            }
            else
            {
                go = Instantiate(fistTab.gameObject) as GameObject;
                go.transform.parent = m_tabsObj.transform;
                go.transform.localPosition = fistTab.localPosition + new Vector3(i * m_spacing, 0, 0);
                go.transform.localScale = fistTab.localScale;

                m_tabs.Add(go.transform);
            }
            go.name = "Tab " + i;

            Transform inactive = go.transform.Find("Inactive");
            Transform active = go.transform.Find("Active");

            if (m_currentIndex == i)
            {
                inactive.gameObject.SetActive(false);
                active.gameObject.SetActive(true);
            }
            else
            {
                inactive.gameObject.SetActive(true);
                active.gameObject.SetActive(false);
            }
        }

        List<NLuaTabItemWidget> tabItems = GetTabItemList();
        if (tabItems == null || tabItems.Count == 0)
        {
            Debug.LogError("没有TabItem子项，至少需要手动添加一个");
            return;
        }

        if (m_useCommonTemplate)
        {
            if (tabItems == null || tabItems.Count != 1)
            {
                Debug.LogError("当m_useCommonTemplate为true（使用共同模板时），tabItem的数量必须为1，请删除或关闭多余的.");
            }
        }
        else
        {
            NLuaTabItemWidget fistTabItem = tabItems[0];
            for (int i = 0; i < m_tabCount; i++)
            {
                GameObject go;
                if (i < tabItems.Count)
                {
                    go = tabItems[i].gameObject;
                }
                else
                {
                    go = Instantiate(fistTabItem.gameObject) as GameObject;
                    go.transform.parent = m_viewObj.transform;
                    go.transform.localPosition = fistTabItem.transform.localPosition;
                    go.transform.localScale = fistTabItem.transform.localScale;

                    m_tabItems.Add(go.GetComponent<NLuaTabItemWidget>());
                }
                go.name = "TabItem " + i;
                if (m_currentIndex == i)
                {
                    go.SetActive(true);
                }
                else
                {
                    go.SetActive(false);
                }
            }
        }

        if (tabs.Count > m_tabCount || tabItems.Count > m_tabCount)
        {
            Debug.LogError(string.Format("tabs Count:{0}, tabItems Count:{1}, m_tabCount:{2}. 请检查，将超出的删除或关闭!!!", tabs.Count, tabItems.Count, m_tabCount));
        }
    }
#endif

    public int TabCount
    {
        get { return m_tabCount; }
    }

    public int CurrentIndex
    {
        get { return m_currentIndex; }
    }

    public List<Transform> GetTabList()
    {
#if UNITY_EDITOR
        Transform myTrans = m_tabsObj.transform;
        m_tabs = new List<Transform>();

        for (int i = 0; i < myTrans.childCount; ++i)
        {
            Transform t = myTrans.GetChild(i);
            if (t && t.gameObject.activeSelf)
                m_tabs.Add(t);
        }
#endif
        return m_tabs;
    }

    public Transform GetTab(int index)
    {
        List<Transform> list = GetTabList();
        return (index < list.Count) ? list[index] : null;
    }

    public List<NLuaTabItemWidget> GetTabItemList()
    {
#if UNITY_EDITOR
        Transform myTrans = m_viewObj.transform;
        m_tabItems = new List<NLuaTabItemWidget>();

        for (int i = 0; i < myTrans.childCount; ++i)
        {
            Transform t = myTrans.GetChild(i);
            if (t)
            {
                NLuaTabItemWidget tabItem = t.GetComponent<NLuaTabItemWidget>();
                if (tabItem)
                {
                    m_tabItems.Add(tabItem);
                }
            }
        }
#endif
        return m_tabItems;
    }

    public NLuaTabItemWidget GetTabItem(int index)
    {
        List<NLuaTabItemWidget> list = GetTabItemList();
        return (index < list.Count) ? list[index] : null;
    }

    void Start()
    {
        OpenTabItem(CurrentIndex);
    }

    public void OpenTabItem(int index)
    {
        Transform tab = GetTab(index);
        Transform currentTab = GetTab(m_currentIndex);
        if (tab != null)
        {
            if (m_currentIndex != index)
            {
                Transform inactive = tab.Find("Inactive");
                Transform active = tab.Find("Active");
                inactive.gameObject.SetActive(false);
                active.gameObject.SetActive(true);

                inactive = currentTab.Find("Inactive");
                active = currentTab.Find("Active");
                inactive.gameObject.SetActive(true);
                active.gameObject.SetActive(false);
            }
        }
        else
        {
            NDebug.LogError("tab({0}) is null.", index);
        }

        NLuaTabItemWidget tabItem;
        if (m_useCommonTemplate)
        {
            tabItem = GetTabItem(0);
        }
        else
        {
            tabItem = GetTabItem(index);

            if (m_currentIndex != index)
            {
                NLuaTabItemWidget currentTabItem = GetTabItem(m_currentIndex);
                currentTabItem.gameObject.SetActive(false);
                tabItem.gameObject.SetActive(true);
            }
        }

        if (tabItem != null)
        {
            m_currentIndex = index;
            tabItem.Init(index);
        }
        else
        {
            NDebug.LogError("tabItem({0}) is null.", index);
        }
    }
}
