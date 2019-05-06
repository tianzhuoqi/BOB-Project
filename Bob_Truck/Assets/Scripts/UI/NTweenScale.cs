using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NTweenScale : TweenScale
{
    NTableView nTableView;
    NLuaListCellWidget nCell;

    protected override void OnUpdate(float factor, bool isFinished)
    {
        value = from * (1f - factor) + to * factor;

        if (updateTable)
        {
            if (nTableView == null)
            {
                nTableView = NGUITools.FindInParents<NTableView>(gameObject);
                if (nTableView == null) { updateTable = false; return; }
            }

            if (nCell == null)
            {
                nCell = NGUITools.FindInParents<NLuaListCellWidget>(gameObject);
                if (nCell == null) { updateTable = false; return; }
            }

            Bounds b = NGUIMath.CalculateRelativeWidgetBounds(transform, false);
            Vector3 scale = transform.localScale;
            b.size = Vector3.Scale(b.size, scale);

            nTableView.Reposition(nCell.Index, b.size.y);
        }
    }
}
