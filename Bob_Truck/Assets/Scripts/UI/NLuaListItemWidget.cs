using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLuaListItemWidget : NLuaUIWidgetBase
{
    UIDragScrollView m_dragScrollView;
    public UIDragScrollView DragScrollView
    {
        get
        {
            return m_dragScrollView;
        }
        set
        {
            m_dragScrollView = value;
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

    public virtual void DrawCell(int index, int cellIndex, int itemsCount)
    {
        NManagerLua.Instance.CallObjectFunction(m_handle, "DrawCell", index, cellIndex, itemsCount);
    }
}
