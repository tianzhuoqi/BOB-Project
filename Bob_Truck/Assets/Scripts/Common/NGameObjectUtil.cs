﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
public class NGameObjectUtil
{
    private static Vector3 Pos = Vector3.zero;

    private static Quaternion rotation = Quaternion.identity;

    private static Vector3 Scale = Vector3.zero;

    public static void SetPosition(GameObject go, float x, float y, float z)
    {
        Pos.x = x;
        Pos.y = y;
        Pos.z = z;
        go.transform.position = Pos;
    }

    public static void SetRotation(GameObject go, float x, float y, float z, float w)
    {
        rotation.x = x;
        rotation.y = y;
        rotation.z = z;
        rotation.w = w;
        go.transform.rotation = rotation;
    }

    public static void SetLocalPosition(GameObject go, float x, float y, float z)
    {
        Pos.x = x;
        Pos.y = y;
        Pos.z = z;
        go.transform.localPosition = Pos;
    }

    public static void SetLocalRotation(GameObject go, float x, float y, float z, float w)
    {
        rotation.x = x;
        rotation.y = y;
        rotation.z = z;
        rotation.w = w;
        go.transform.localRotation = rotation;
    }

    public static void SetLocalRotation(GameObject go, float x, float y, float z)
    {
        go.transform.localRotation = Quaternion.Euler(x, y, z);
    }

    public static void SetScale(GameObject go, float x, float y, float z)
    {
        Scale.x = x;
        Scale.y = y;
        Scale.z = z;
        go.transform.localScale = Scale;
    }

    public static void SetLineRenderPos(GameObject go, int nPosIndex, float x, float y, float z)
    {
        if (null == go)
            return;
        LineRenderer line = go.GetComponent<LineRenderer>();
        if (null == line)
            return;
        Pos.x = x;
        Pos.y = y;
        Pos.z = z;
        line.SetPosition(nPosIndex, Pos);
    }


    static Plane s_Floor = new Plane(Vector3.up, Vector3.zero);
    public static Vector3 RayCastFloor(Ray ray, Plane plane)
    {
        float fHitPt = 0;
        Vector3 hitpt = Vector3.zero;
        if (plane.Raycast(ray, out fHitPt))
        {
            hitpt = ray.origin + fHitPt * ray.direction;
        }
        return hitpt;
    }
    public static Vector3 ScreenPickCastFloor(float x, float y)
    {
        Camera cam = Camera.main;
        if (null == cam)
            return Vector3.zero;
        Ray ray = cam.ScreenPointToRay(new Vector2(x, y));
        return RayCastFloor(ray, s_Floor);
    }


    public static Vector3 CamForwardCastFloor()
    {
        Camera cam = Camera.main;
        if (null == cam)
            return Vector3.zero;
        Ray ray = new Ray(cam.transform.position, cam.transform.forward);
        return RayCastFloor(ray, s_Floor);
    }

    //3D世界坐标转UI坐标
    public static Vector2 World3DPos2WorldUIPos(float x, float y, float z)
    {
        Camera cam3d = Camera.main;
        Camera cam2d = UICamera.mainCamera;
        if (null == cam3d || null == cam2d)
            return Vector2.zero;
        Pos.x = x;
        Pos.y = y;
        Pos.z = z;
        Vector3 vScre = cam3d.WorldToScreenPoint(Pos);
        vScre.z = 0;
        return cam2d.ScreenToWorldPoint(vScre);
    }

    //UI坐标转屏幕坐标
    public static Vector2 UIPos2ScreenPoint(float x, float y)
    {
        Camera cam2d = UICamera.mainCamera;
        if (null == cam2d)
            return Vector2.zero;
        Pos.x = x;
        Pos.y = y;
        Pos.z = 0;
        Vector3 vScre = cam2d.WorldToScreenPoint(Pos);
        vScre.z = 0;
        return vScre;
    }

    //屏幕坐标转UI坐标
    public static Vector2 ScreenPoint2UIPos(float x, float y)
    {
        Camera cam2d = UICamera.mainCamera;
        if (null == cam2d)
            return Vector2.zero;
        Pos.x = x;
        Pos.y = y;
        Pos.z = 0;
        Vector3 vScre = cam2d.ScreenToWorldPoint(Pos);
        vScre.z = 0;
        return vScre;
    }

    public static bool IsWorld3DPosInScreen(float x, float y, float z)
    {
        Camera cam3d = Camera.main;
        Camera cam2d = UICamera.mainCamera;
        if (null == cam3d || null == cam2d)
            return false;
        Pos.x = x;
        Pos.y = y;
        Pos.z = z;
        Vector3 vScre = cam3d.WorldToScreenPoint(Pos);
        if (vScre.x < 0 || vScre.x > Screen.width || vScre.y < 0 || vScre.y > Screen.height)
            return false;
        return true;
    }

    public static Vector3 ScreenPickCastFloorByLayer(float x, float y, string mask)
    {
        return ScreenPickCastFloorByLayer(x, y, mask, null);
    }

    public static Vector3 ScreenPickCastFloorByLayer(float x, float y, string mask, Camera cam)
    {
        if (null == cam)
            cam = Camera.main;
        if (null == cam)
            return Vector3.zero;
        Ray ray = cam.ScreenPointToRay(new Vector2(x, y));
        RaycastHit hit;
        LayerMask lm = 1 << LayerMask.NameToLayer(mask);
        if (Physics.Raycast(ray, out hit, 1000000000, lm))
        {
            return hit.point;
        }
        else
        {
            return Vector3.zero;
        }
    }

    //如果src是dst的子节点，返回src在dst的相对位置
    public static Vector3 ToLocalPos(Transform src, Transform dst)
    {
        Vector3 v = Vector3.zero;
        Transform parent = src.transform.parent;
        Transform wid = src.transform;
        do
        {
            Vector3 vLocal = wid.transform.localPosition;
            v += vLocal;
            wid = parent;
            parent = parent.parent;
        }
        while (parent != null && parent != dst.transform);
        return v;
    }

    public static List<Material> GetMeshRendererMaterials(MeshRenderer renderer)
    {
        return new List<Material>(renderer.materials);
    }

    public static void SetMeshRendererMaterials(MeshRenderer renderer, List<Material> materials)
    {
        renderer.materials = materials.ToArray();
    }

    public static void SetMaterialsColor(Material material, string name, float r, float g, float b)
    {
        material.SetColor(name, new Color(r, g, b));
    }
    public static void SetMaterialsFloat(Material material, string name, float f)
    {
        material.SetFloat(name, f);
    }
    public static void SetMaterialsTexture(Material material, string name, string texture)
    {
        var loader = NAssetFileLoader.Load(texture, null, LoaderMode.Sync);
        if (null == loader)
            return;
        Texture t = loader.Asset as Texture;
        material.SetTexture(name, t);
    }

    public static Camera SetUITextureMainTex(UITexture uiTexture, Transform t)
    {
        if (null == t || null == uiTexture)
            return null;
        Camera cam = t.GetComponentInChildren<Camera>();
        if (null == cam)
            return null;
        uiTexture.mainTexture = cam.targetTexture;
        return cam;
    }

    public static Vector3 ScreenPickCastFloor(float x, float y, float fPanelH, Camera cam)
    {
        if (null == cam)
            cam = Camera.main;
        if (null == cam)
            return Vector3.zero;
        Ray ray = cam.ScreenPointToRay(new Vector2(x, y));
        Plane p = new Plane(Vector3.up, fPanelH);
        return RayCastFloor(ray, p);
    }

    public static void SendMessage(GameObject go, string funcName)
    {
        SendMessage(go, funcName, null);
    }

    public static void SendMessage(GameObject go, string funcName, object obj)
    {
        if (go != null)
        {
            go.SendMessage(funcName, obj, SendMessageOptions.DontRequireReceiver);
        }
    }

    public static void SetFlip(UISprite sprite, int flip)
    {
        if (sprite != null)
        {
            sprite.flip = (UIBasicSprite.Flip)flip;
        }
    }

    public static Vector3 GetCenter(Transform parent)
    {
        Vector3 postion = parent.position;
        Quaternion rotation = parent.rotation;
        Vector3 scale = parent.localScale;

        parent.position = Vector3.zero;
        parent.rotation = Quaternion.Euler(Vector3.zero);
        parent.localScale = Vector3.one;

        Vector3 center = Vector3.zero;
        Renderer[] renders = parent.GetComponentsInChildren<Renderer>();
        foreach (Renderer child in renders)
        {
            center += child.bounds.center;
        }
        if (renders.Length > 0)
        {
            center /= renders.Length;
        }
        Bounds bounds = new Bounds(center, Vector3.zero);
        foreach (Renderer child in renders)
        {
            bounds.Encapsulate(child.bounds);
        }

        parent.position = postion;
        parent.rotation = rotation;
        parent.localScale = scale;

        foreach (Transform t in parent)
        {
            t.position = t.position - bounds.center;
        }

        parent.transform.position = bounds.center + parent.position;
        return parent.transform.position;
    }

    public static void SetButtonState(UIButton button, int state)
    {
        UIButtonColor.State buttonState = (UIButtonColor.State)state;
        button.enabled = buttonState != UIButtonColor.State.Disabled;
        button.SetState(buttonState, false);
    }
}
