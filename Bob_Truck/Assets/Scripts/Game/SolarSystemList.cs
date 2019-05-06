using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SolarSystemList : MonoBehaviour {

    public List<SolarSystem> m_SolarSystemList = new List<SolarSystem>();

    public int m_mode = 0;

    public GameObject Star_Trails;

    public TouchControl tc;

    public GameObject cube;

    public List<LineRenderer> m_lineRendererList = new List<LineRenderer>();
    public List<Vector3> m_lineRendererPos0 = new List<Vector3>();
    public List<Vector3> m_lineRendererPos1 = new List<Vector3>();

    public List<int> m_indexA = new List<int>();
    public List<int> m_indexB = new List<int>();

    private GUIStyle guiStyle = new GUIStyle();

    public bool showName = true;

    void Start()
    {

        for (int i = 0; i < m_indexA.Count; i++)
        {
            if (m_indexA[i] < 0)
                continue;

            var go = GameObject.Instantiate(Star_Trails) as GameObject;
            LineRenderer lr = go.GetComponent<LineRenderer>();

            m_lineRendererList.Add(lr);
            m_lineRendererPos0.Add(m_SolarSystemList[m_indexA[i]].Sun.transform.position);
            m_lineRendererPos1.Add(m_SolarSystemList[m_indexB[i]].Sun.transform.position);

            var box = GameObject.Instantiate(cube, m_SolarSystemList[m_indexA[i]].Sun.transform.position + (m_SolarSystemList[m_indexB[i]].Sun.transform.position - m_SolarSystemList[m_indexA[i]].Sun.transform.position).normalized * m_SolarSystemList[m_indexA[i]].radius, Quaternion.identity, m_SolarSystemList[m_indexA[i]].details.transform);
            var box1 = GameObject.Instantiate(cube, m_SolarSystemList[m_indexB[i]].Sun.transform.position - (m_SolarSystemList[m_indexB[i]].Sun.transform.position - m_SolarSystemList[m_indexA[i]].Sun.transform.position).normalized * m_SolarSystemList[m_indexB[i]].radius, Quaternion.identity, m_SolarSystemList[m_indexB[i]].details.transform);

            box.transform.LookAt(m_SolarSystemList[m_indexA[i]].Sun.transform.position);
            box1.transform.LookAt(m_SolarSystemList[m_indexB[i]].Sun.transform.position);
        }

        guiStyle.fontSize = 20;
        guiStyle.normal.textColor = Color.white;
    }

    void OnGUI()
    {
        if (!showName)
            return;
        for (int i = 0; i < m_SolarSystemList.Count; i++)
        {
            Vector3 pos = Camera.main.WorldToViewportPoint(m_SolarSystemList[i].transform.position);
            GUI.Label(new Rect(pos.x * Screen.width - 60, Screen.height - pos.y * Screen.height - 40, 200, 200), m_SolarSystemList[i].name + ":" + i, guiStyle);
        }
    }

    void Update()
    {
        for (int i = 0; i < m_SolarSystemList.Count; i++)
        {
            m_SolarSystemList[i].ShowPointOrDetails(tc.m_scalePercent);
        }
        for (int i = 0; i < m_lineRendererList.Count; i++)
        {
            if (m_indexA[i] < 0)
                continue;

            if (tc.m_scalePercent <= 0)
            {
                m_lineRendererList[i].SetPosition(0, m_lineRendererPos0[i]);
                m_lineRendererList[i].SetPosition(1, m_lineRendererPos1[i]);
            }
            else
            {
                var percent = tc.m_scalePercent;
                if (percent > 20)
                    percent = 20;

                Vector3 dir = (m_lineRendererPos0[i] - m_lineRendererPos1[i]).normalized;

                m_lineRendererList[i].SetPosition(0, m_lineRendererPos0[i] - (dir * m_SolarSystemList[m_indexA[i]].radius * percent / 20));
                m_lineRendererList[i].SetPosition(1, m_lineRendererPos1[i] + (dir * m_SolarSystemList[m_indexB[i]].radius * percent / 20));
            }
        }
    }
}
