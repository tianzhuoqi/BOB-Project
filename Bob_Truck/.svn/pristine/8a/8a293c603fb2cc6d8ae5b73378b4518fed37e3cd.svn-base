using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLuaListCellWidget : NLuaUIWidgetBase
{
#if UNITY_EDITOR
    [Header("每个Item的宽度")]
    public float m_width = 0.0f;

    GameObject m_dynamicObject;

    [NoToLua]
    [ContextMenu("InitCell")]
    public void InitCell()
    {
        Transform trans = gameObject.transform;
        int count = 0;
        float start = -(m_items.Length - 1) * m_width * 0.5f;

        for (int i = 0; i < trans.childCount; ++i)
        {
            NLuaListItemWidget item = trans.GetChild(i).GetComponent<NLuaListItemWidget>();
            if (item != null)
            {
                item.gameObject.SetActive(true);
                //init dynamic object
                m_dynamicObject = item.gameObject;

                m_items[i] = item;
                item.transform.localPosition = new Vector3(start + i * m_width, 0, 0);

                count++;
            }
        }

        //NLuaListCellWidget数量不足时自动补充
        int needCout = m_items.Length - count;
        while (needCout > 0)
        {
            var go = Instantiate(m_dynamicObject) as GameObject;
            var goTransform = go.transform;

            goTransform.parent = m_dynamicObject.transform.parent;
            go.name = "Item";

            var cloneTransform = m_dynamicObject.transform;
            goTransform.localScale = cloneTransform.localScale;
            goTransform.localPosition = cloneTransform.localPosition;
            goTransform.localRotation = cloneTransform.localRotation;

            // 动态创建的OBJ需要先隐掉，再通过逻辑判断是否开启，否则会出现重叠问题
            go.SetActive(true);

            NLuaListItemWidget item = goTransform.GetComponent<NLuaListItemWidget>();
            m_items[count] = item;
            item.transform.localPosition = new Vector3(start + count * m_width, 0, 0);

            count++;
            needCout--;
        }
    }
#endif

    public UIDragScrollView m_dragScrollView;               //UIDragScrollView
    public NLuaListItemWidget[] m_items;                    //包含的ListItem集合

    private int m_index = -1;
    public int Index                                        //cell对应索引
    {
        get { return m_index; }
    }

    bool m_isOpen = false;
    bool m_animation = false;

    [Header("收缩控件子菜单")]
    [SerializeField]
    private NTweenScale m_subView;                           //收缩控件子菜单
    private static Vector3 zeroY = new Vector3(1, 0, 1);

    [SerializeField]
    private NTableView m_tableView;

    protected void Start()
    {
        if (m_items != null)
        {
            for (int i = 0; i < m_items.Length; i++)
            {
                m_items[i].DragScrollView = m_dragScrollView;
            }
        }

        Transform temp = transform.Find("SubView");
        if (temp != null && temp.GetComponent<NTweenScale>() != null)
        {
            m_subView = temp.GetComponent<NTweenScale>();
            m_subView.AddOnFinished(OnTweenFinished);

            if (m_tableView == null)
            {
                m_tableView = NGUITools.FindInParents<NTableView>(gameObject);
            }
        }
    }

    protected override void OnPress(bool pressed)
    {
        base.OnPress(pressed);

        if (m_dragScrollView != null) m_dragScrollView.OnPress(pressed);
    }

    protected override void OnDrag(Vector2 delta)
    {
        base.OnDrag(delta);

        if (m_dragScrollView != null) m_dragScrollView.OnDrag(delta);
    }

    protected override void OnScroll(float delta)
    {
        base.OnScroll(delta);

        if (m_dragScrollView != null) m_dragScrollView.OnScroll(delta);
    }

    public virtual void DrawCell(int index, int count = 0)
    {
        m_index = index;
        if (m_items == null || m_items.Length == 0)
        {
            NManagerLua.Instance.CallObjectFunction(m_handle, "DrawCell", index, m_isOpen);
        }
        else
        {
            int itemsCount = m_items.Length;
            for (int i = 0; i < itemsCount; i++)
            {
                if (i < count)
                {
                    m_items[i].gameObject.SetActive(true);
                    m_items[i].DrawCell(i, index, itemsCount);
                }
                else
                {
                    m_items[i].gameObject.SetActive(false);
                }
            }
        }
    }

    public bool CanDisable()
    {
        bool ret = true;
        if (UICamera.currentTouch == null) return ret;

        var go = UICamera.currentTouch.pressed.transform;
        var self = this.transform;
        while (go != null)
        {
            if (go == self)
            {
                ret = false;
                break;
            }
            else
            {
                go = go.parent;
            }
        }

        return ret;
    }

    public void ShowSubView(bool play)
    {
        if (m_subView != null && !m_subView.gameObject.activeSelf)
        {
            if (play && !m_animation)
            {
                m_subView.gameObject.SetActive(true);
                m_subView.tweenFactor = 0;
                m_subView.enabled = true;
                UITweener tw = m_subView as UITweener;
                tw.PlayForward();
                m_animation = true;
            }
            else
            {
                m_subView.enabled = false;
                m_subView.transform.localScale = Vector3.one;
                m_subView.tweenFactor = 1;
                m_subView.gameObject.SetActive(true);
                m_animation = false;
            }
        }
        m_isOpen = true;
    }

    public void HideSubView(bool play)
    {
        if (m_subView != null && m_subView.gameObject.activeSelf)
        {
            if (play && !m_animation)
            {
                m_subView.gameObject.SetActive(true);
                m_subView.tweenFactor = 1;
                m_subView.enabled = true;
                UITweener tw = m_subView as UITweener;
                tw.PlayReverse();
                m_animation = true;
            }
            else
            {
                m_subView.gameObject.SetActive(false);
                m_subView.enabled = false;
                m_subView.transform.localScale = zeroY;
                m_subView.tweenFactor = 0;
                m_animation = false;

                if (m_tableView != null)
                {
                    m_tableView.ScrollViewToDown();
                }
            }
        }
        m_isOpen = false;
    }

    void OnTweenFinished()
    {
        m_subView.gameObject.SetActive(m_subView.tweenFactor == 1 || m_isOpen);
        m_animation = false;

        if (m_tableView != null)
        {
            if (m_subView.gameObject.activeSelf)
            {
                m_tableView.ScrollViewToPos(Index);
            }
            else
            {
                m_tableView.ScrollViewToDown();
            }
        }
    }
}
