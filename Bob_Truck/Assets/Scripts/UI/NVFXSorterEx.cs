using UnityEngine;
using System.Collections;

public class NVFXSorterEx : MonoBehaviour
{
    public int depth;
    public UIPanel parentPanel;

    private int panelRq;
    private ParticleSystem[] _particleSystems;

    void Start()
    {
        panelRq = -1;
        _particleSystems = gameObject.GetComponentsInChildren<ParticleSystem>(true);
        if (parentPanel == null)
            parentPanel = gameObject.GetComponentInParent<UIPanel>();
    }

    void OnDestroy()
    {
        if (parentPanel != null)
            parentPanel = null;
    }

    void OnEnable()
    {
        panelRq = -1;
        HandUpdate();
    }

    public void HandUpdate()
    {
        if (parentPanel != null && parentPanel.startingRenderQueue + depth != panelRq)
        {
            panelRq = parentPanel.startingRenderQueue + depth;

            for (int i = 0; i < _particleSystems.Length; i++)
            {
                Material[] ms = _particleSystems[i].GetComponent<Renderer>().materials;
                for (int j = 0; j < ms.Length; j++)
                {
                    ms[j].renderQueue = panelRq;
                }
            }
        }
    }

    public void Play()
    {
        if (!parentPanel.Equals(null))
        {
            for (int i = 0; i < _particleSystems.Length; i++)
            {
                _particleSystems[i].Play();
            }
        }
    }
}
