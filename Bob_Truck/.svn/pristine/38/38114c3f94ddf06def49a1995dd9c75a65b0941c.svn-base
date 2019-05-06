using UnityEngine;
using System;
using System.Collections.Generic;
using System.Collections;

public class NLanguageTextByKey : MonoBehaviour
{
    public string m_TextKey = string.Empty;
    public string m_TextType = string.Empty;
    private UILabel m_Label = null;

    void Awake()
    {
        m_Label = gameObject.GetComponent<UILabel>();
        if (m_TextKey != string.Empty && m_TextType != string.Empty)
            m_Label.text = GetText();
    }

    string GetText()
    {
        object[] re = NManagerLua.Instance.CallFunction("GetLanguageText", m_TextType, m_TextKey);
        return Convert.ToString(re[0]);
    }

    //动态修改text
    public void ResetText(string type, string key)
    {
        m_TextType = type;
        m_TextKey = key;
        if (m_TextKey != string.Empty && m_TextType != string.Empty)
            m_Label.text = GetText();
    }
}
