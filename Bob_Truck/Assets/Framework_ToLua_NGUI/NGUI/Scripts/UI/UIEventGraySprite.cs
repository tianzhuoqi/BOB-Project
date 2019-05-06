using UnityEngine;
using System.Collections;
using System;

public class UIEventGraySprite : UISprite
{
    protected UIPanel panelObj = null;
    protected Material GrayMaterial;

    /// <summary>
    /// ngui对Sprite进行渲染时候调用
    /// </summary>
    /// <value>The material.</value>
    public override Material material
    {
        get
        {
            Material mat = base.material;

            if (mat == null)
            {
                mat = (mAtlas != null) ? mAtlas.spriteMaterial : null;
            }

            if (GrayMaterial != null)
            {
                return GrayMaterial;
            }
            else
            {
                return mat;
            }
        }
    }

    /// <summary>
    /// 调用此方法可将Sprite变灰
    /// </summary>
    /// <value>The material.</value>
    public void SetGray()
    {
        Material mat = new Material(Shader.Find("Unlit/Transparent ColoredGray"));
        if (mat == null)
            Debug.Log("Transparent ColoredGray not find");
        mat.mainTexture = material.mainTexture;
        GrayMaterial = mat;

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
        GrayMaterial = null;
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
