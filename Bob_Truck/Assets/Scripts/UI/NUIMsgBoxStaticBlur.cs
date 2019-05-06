using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//用于生成msgbox背景mask的模糊纹理
public class NUIMsgBoxStaticBlur : MonoBehaviour {

    public UITexture uiTex;
    public Material mat;
    //降采样次数  
    [Range(1, 6), Tooltip("[降采样次数]向下采样的次数。此值越大,则采样间隔越大,需要处理的像素点越少,运行速度越快。")]
    public int DownSampleNum = 2;
    //模糊扩散度  
    [Range(0.0f, 20.0f), Tooltip("[模糊扩散度]进行高斯模糊时，相邻像素点的间隔。此值越大相邻像素间隔越远，图像越模糊。但过大的值会导致失真。")]
    public float BlurSpreadSize = 3.0f;
    //迭代次数  
    [Range(0, 8), Tooltip("[迭代次数]此值越大,则模糊操作的迭代次数越多，模糊效果越好，但消耗越大。")]
    public int BlurIterations = 3;

    RenderTexture blurTex;

    public void GaussianBlur()
    {
        //截屏 获得RenderTexutre
        blurTex = CaptureScreen();
        //使用shader处理
        uiTex.mainTexture = ApplyBlur();
        RenderTexture.ReleaseTemporary(blurTex);
    }
    /// <summary>
    /// 利用rendertexutre获得主相机当前渲染画面。
    /// </summary>
    RenderTexture CaptureScreen()
    {
        /*
         * ToDo. 如果A界面是个全屏界面，如果它再打开B界面，而B界面GaussianBlur,这时候会有问题,因为A界面些时处于一个alpha==0的状态
         * 
         * */
        Rect rect = new Rect(0, 0, Screen.width, Screen.height);
        RenderTexture preTex;
        RenderTexture renderTex = RenderTexture.GetTemporary((int)rect.width, (int)rect.height, 24, RenderTextureFormat.ARGB32);
        //每个camera都渲染一帧，得到当前的最终画面
        foreach (var camera in Camera.allCameras)
        {
            preTex = camera.targetTexture;
            camera.targetTexture = renderTex;
            camera.Render();
            camera.targetTexture = preTex;
        }
        
        return renderTex;
    }

    Texture ApplyBlur()
    {
        float widthMod = 1.0f / (1.0f * DownSampleNum);
        int renderWidth = blurTex.width >> DownSampleNum;
        int renderHeight = blurTex.height >> DownSampleNum;


        for (int i = 0; i < BlurIterations; i++)
        {
            //设置参数
            mat.SetFloat("_DonwSamplerPara", BlurSpreadSize * widthMod + i);
            RenderTexture temp = RenderTexture.GetTemporary(renderWidth, renderHeight, 0, blurTex.format);
            //水平采样
            Graphics.Blit(blurTex, temp, mat, 1);
            RenderTexture.ReleaseTemporary(blurTex);
            blurTex = temp;
            //垂直采样
            temp = RenderTexture.GetTemporary(renderWidth, renderHeight, 0, blurTex.format);
            Graphics.Blit(blurTex, temp, mat, 2);
            RenderTexture.ReleaseTemporary(blurTex);
            blurTex = temp;
        }
        //读取RenderTexture为Texture2D
        RenderTexture.active = blurTex;

        Texture2D finalTex = new Texture2D(blurTex.width, blurTex.height);
        Rect rect = new Rect(0, 0, blurTex.width, blurTex.height);
        finalTex.ReadPixels(rect, 0, 0);
        finalTex.Apply();
        RenderTexture.active = null;

        return finalTex;
    }
}
