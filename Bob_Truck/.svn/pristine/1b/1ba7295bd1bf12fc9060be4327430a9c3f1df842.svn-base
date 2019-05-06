using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NLoaderTexture : MonoBehaviour 
{
    public string path;
	void Start () 
    {
        UITexture tex = gameObject.GetComponent<UITexture>();
        NAbstractResourceLoader loader = NManagerResourceModule.LoadBundle(path);
        if (loader != null)
            tex.mainTexture = loader.ResultObject as Texture;
	}
}
