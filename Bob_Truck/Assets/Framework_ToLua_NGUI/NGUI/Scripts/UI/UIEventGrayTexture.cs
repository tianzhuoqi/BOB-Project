using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIEventGrayTexture : UITexture
{
    protected UIPanel panelObj = null;

    /// <summary>
    /// 调用此方法可将Sprite变灰
    /// </summary>
    /// <value>The material.</value>
    public void SetGray()
    {
        shader = Shader.Find("Unlit/Transparent ColoredGray");
        RefreshPanel(gameObject);
    }

    /// <summary>
    /// 隐藏按钮，setActive能不用尽量少用，效率问题。
    /// </summary>
    /// <value>The material.</value>
    public void SetVisible(bool isVisible)
    {
        if (isVisible)
        {
            transform.localScale = new Vector3(1, 1, 1);
        }
        else
        {
            transform.localScale = new Vector3(0, 0, 0);
        }
    }

    /// <summary>
    /// 将按钮置为禁止点击状态，false为禁用状态
    /// </summary>
    /// <value>The material.</value>
    public void SetEnabled(bool isEnabled)
    {
        if (isEnabled)
        {
            BoxCollider lisener = gameObject.GetComponent<BoxCollider>();
            if (lisener)
            {
                lisener.enabled = true;
            }

            SetNormal();
        }
        else
        {
            BoxCollider lisener = gameObject.GetComponent<BoxCollider>();
            if (lisener)
            {

                lisener.enabled = false;
            }

            SetGray();
        }
    }

    /// <summary>
    /// 将GrayMaterial置为null，此时会调用默认材质，刷新panel才会重绘Sprite
    /// </summary>
    /// <value>The material.</value>
    public void SetNormal()
    {
        shader = Shader.Find("Unlit/Transparent Colored");
        RefreshPanel(gameObject);
    }

    void RefreshPanel(GameObject go)
    {
        if (panelObj == null)
        {
            panelObj = NGUITools.FindInParents<UIPanel>(go);
        }
        if (panelObj != null)
        {
            panelObj.enabled = false;
            panelObj.enabled = true;
        }
    }
}
