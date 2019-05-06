﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

/// <summary>
/// 场景加载
/// </summary>
public class NLoadScene
{
    public static string ActiveSceneName
    {
        get { return SceneManager.GetActiveScene().name; }
    }

    public static AsyncOperation LoadSceneAsync(string sceneName)
    {
        AsyncOperation async = SceneManager.LoadSceneAsync(sceneName);
        return async;
    }

    public static void LoadScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }
}