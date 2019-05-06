using System.Collections;
using System.Collections.Generic;
using UnityEngine;

struct stHullPart //舰体部位描述
{
    uint unHullID; //舰体id
    uint unAttachIndex;//依附舰体索引
    uint unAttachPart;//依附部位
}
struct stShipModule
{
    uint unTechID;//组装技术
    stHullPart[] unHullMats;//舰体材料
    uint[] unCpntMats;//组件材料
}

public class RenderTargetSet : MonoBehaviour
{
    public Camera cam;
    RenderTexture rt;
    void Awake()
    {
        if (null == cam)
            return;
        rt = RenderTexture.GetTemporary(NUICameraAdjustor.standard_width, NUICameraAdjustor.standard_height, 24, RenderTextureFormat.ARGB32);
        rt.filterMode = FilterMode.Bilinear;

        cam.targetTexture = rt;
    }

    void OnDestroy()
    {
        if (null != cam)
            cam.targetTexture = null;
        if (null != rt)
        {
            RenderTexture.ReleaseTemporary(rt);
            rt = null;
        }
    }
}
