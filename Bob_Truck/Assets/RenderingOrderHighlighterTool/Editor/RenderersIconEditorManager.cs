﻿//Zenith Code 2014
using UnityEditor;
using UnityEngine;
using System.Globalization;
using System.Collections.Generic;
using Object = UnityEngine.Object;

[InitializeOnLoad]
public class RenderersIconEditorManager
{
    private static List<RendererObject> _rendererObjects;
    private const float TEXTURE_WIDTH = 50.0f;
    private const float TEXTURE_HEIGHT = 15.0f;
    private const float OFFSET_FROM_LEFT = 20f;
    private const int CUSTOM_NAME_MAX_LENGTH = 5;

    static RenderersIconEditorManager()
    {
        EditorApplication.update += UpdateObjectList;
        EditorApplication.hierarchyWindowItemOnGUI += RefreshHierarchy;
    }


    private static void UpdateObjectList()
    {
        _rendererObjects = RenderingHighlighterUtility.GetRenderersObjectList();
    }


    private static void RefreshHierarchy(int instanceId, Rect selectionRect)
    {
        if (_rendererObjects == null)
        {
            return;
        }

        var rect = new Rect(selectionRect) { x = selectionRect.width + selectionRect.x - TEXTURE_WIDTH - OFFSET_FROM_LEFT, width = TEXTURE_WIDTH, height = TEXTURE_HEIGHT };

        foreach (RendererObject rendererObject in _rendererObjects)
        {
            if (rendererObject.instanceId == instanceId)
            {
                //Draws icon and sort order number centered on icon
                var highlighterForLayer = RenderingHighlighterUtility.GetRenderingHighlighterForLayer(rendererObject.sortingLayerName);
                if (highlighterForLayer.layerTexture != null)
                {
                    if (GUI.Button(rect, string.Empty))
                    {
                        SelectObjectsOnLayer(rendererObject.sortingLayerName);
                    }
                    GUI.DrawTexture(rect, highlighterForLayer.layerTexture);
                    if (highlighterForLayer.layerSecondaryTexture != null)
                    {
                        GUI.DrawTexture(rect, highlighterForLayer.layerSecondaryTexture);
                    }
                }

                var guiStyle = new GUIStyle { normal = { textColor = highlighterForLayer.sortingOrderTextColor } };
                string customLayerName = highlighterForLayer.customLayerName;
                if (!string.IsNullOrEmpty(customLayerName) && customLayerName.Length > CUSTOM_NAME_MAX_LENGTH)
                {
                    customLayerName = customLayerName.Substring(0, CUSTOM_NAME_MAX_LENGTH);
                }
                rect.x += 2;
                GUI.Label(rect, customLayerName, guiStyle);



                if (Mathf.Approximately(rendererObject.sortingOrder2, -999.99f))
                {
                    rect.x += 26; //Centres the number on the icon
                    GUI.Label(rect, rendererObject.sortingOrder.ToString(CultureInfo.InvariantCulture), guiStyle);
                }
                else
                {
                    rect.x += 17; //Centres the number on the icon
                    guiStyle.fontSize = 9;
                    GUI.Label(rect, rendererObject.sortingOrder2.ToString("00.0"), guiStyle);

                }

                Object instance = EditorUtility.InstanceIDToObject(instanceId);
                if (instance == null)
                {
                    return;
                }
                if (Event.current.type == EventType.Repaint)
                {
                    guiStyle.Draw(selectionRect,
                    new GUIContent(string.Empty, string.Format("{0}\nSorting Layer = {1}\nOrder in layer = {2}", instance.name, rendererObject.sortingLayerName, rendererObject.sortingOrder)), instanceId);
                }
            }
        }
    }


    private static void SelectObjectsOnLayer(string sortingLayerName)
    {
        Selection.instanceIDs = RenderingHighlighterUtility.GetObjectIDsOnLayer(sortingLayerName);
    }
}