using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FlexibleGridLayout : LayoutGroup
{
    public enum FitType
    {
        Uniform,
        Width,
        Height,
        FixedRows,
        FixedColumns,
    }

    public FitType fitType;

    public int rows;
    public int columns;
    public Vector2 cellSize;
    public Vector2 spacing;

    public bool fitX;
    public bool fitY;






    [SerializeField] protected float m_Spacing = 0;
    public float spacing_ { get { return m_Spacing; } set { SetProperty(ref m_Spacing, value); } }

    [SerializeField] protected bool m_ChildForceExpandWidth = true;
    public bool childForceExpandWidth { get { return m_ChildForceExpandWidth; } set { SetProperty(ref m_ChildForceExpandWidth, value); } }

    [SerializeField] protected bool m_ChildForceExpandHeight = true;
    public bool childForceExpandHeight { get { return m_ChildForceExpandHeight; } set { SetProperty(ref m_ChildForceExpandHeight, value); } }







    public override void CalculateLayoutInputHorizontal()
    {
        base.CalculateLayoutInputHorizontal();
        CalcAlongAxis(0, false);
        if (fitType == FitType.Width || fitType == FitType.Height || fitType == FitType.Uniform)
        {
            fitX = true;
            fitY = true;
            float sqrRt = Mathf.Sqrt(transform.childCount);
            rows = Mathf.CeilToInt(sqrRt);
            columns = Mathf.CeilToInt(sqrRt);
        }

        if (fitType == FitType.Width || fitType == FitType.FixedColumns || fitType == FitType.Uniform)
        {
            rows = Mathf.CeilToInt(transform.childCount / (float)columns);
        }

        if (fitType == FitType.Height || fitType == FitType.FixedRows || fitType == FitType.Uniform)
        {
            columns = Mathf.CeilToInt(transform.childCount / (float)rows);
        }

        float parentWidth = rectTransform.rect.width;
        float parentHeight = rectTransform.rect.height;

        float cellWidth = (parentWidth / (float)columns) - ((spacing.x / (float)columns) * (columns - 1)) - (padding.left / (float)columns) - (padding.right / (float)columns);
        float cellHeight = (parentHeight / (float)rows) - ((spacing.y / (float)rows) * (rows - 1)) - (padding.top / (float)rows) - (padding.bottom / (float)rows);


        cellSize.x = fitX ? cellWidth : cellSize.x;
        cellSize.y = fitY ? cellHeight : cellSize.y;

        int columnCount = 0;
        int rowCount = 0;

        for (int i = 0; i < rectChildren.Count; i++)
        {
            rowCount = i / columns;
            columnCount = i % columns;

            var item = rectChildren[i];

            var xPos = (cellSize.x * columnCount) + (spacing.x * columnCount) + padding.left;
            var yPos = (cellSize.y * rowCount) + (spacing.y * rowCount) + padding.top;

            SetChildAlongAxis(item, 0, xPos, cellSize.x);
            SetChildAlongAxis(item, 1, yPos, cellSize.y);
        }
            }

    protected void CalcAlongAxis(int axis, bool isVertical)
    {
        float combinedPadding = (axis == 0 ? padding.horizontal : padding.vertical);

        float totalMin = combinedPadding;
        float totalPreferred = combinedPadding;
        float totalFlexible = 0;

        bool alongOtherAxis = (isVertical ^ (axis == 1));
        for (int i = 0; i < rectChildren.Count; i++)
        {
            RectTransform child = rectChildren[i];
            float min = LayoutUtility.GetMinSize(child, axis);
            float preferred = LayoutUtility.GetPreferredSize(child, axis);
            float flexible = LayoutUtility.GetFlexibleSize(child, axis);
            if ((axis == 0 ? childForceExpandWidth : childForceExpandHeight))
                flexible = Mathf.Max(flexible, 1);

            if (alongOtherAxis)
            {
                totalMin = Mathf.Max(min + combinedPadding, totalMin);
                totalPreferred = Mathf.Max(preferred + combinedPadding, totalPreferred);
                totalFlexible = Mathf.Max(flexible, totalFlexible);
            }
            else
            {
                totalMin += min + spacing_;
                totalPreferred += preferred + spacing_;

                // Increment flexible size with element's flexible size.
                totalFlexible += flexible;
            }
        }

        if (!alongOtherAxis && rectChildren.Count > 0)
        {
            totalMin -= spacing_;
            totalPreferred -= spacing_;
        }
        totalPreferred = Mathf.Max(totalMin, totalPreferred);
        SetLayoutInputForAxis(totalMin, totalPreferred, totalFlexible, axis);
    }

    public override void CalculateLayoutInputVertical()
    {
        CalcAlongAxis(1, false);
    }

    public override void SetLayoutHorizontal()
    {
        //throw new System.NotImplementedException();
        //SetChildrenAlongAxis(0, false);
    }

    public override void SetLayoutVertical()
    {
        //throw new System.NotImplementedException();
        //SetChildrenAlongAxis(1, false);
    }

    protected void SetChildrenAlongAxis(int axis, bool isVertical)
    {
        float size = rectTransform.rect.size[axis];

        bool alongOtherAxis = (isVertical ^ (axis == 1));
        if (alongOtherAxis)
        {
            float innerSize = size - (axis == 0 ? padding.horizontal : padding.vertical);
            for (int i = 0; i < rectChildren.Count; i++)
            {
                RectTransform child = rectChildren[i];
                float min = LayoutUtility.GetMinSize(child, axis);
                float preferred = LayoutUtility.GetPreferredSize(child, axis);
                float flexible = LayoutUtility.GetFlexibleSize(child, axis);
                if ((axis == 0 ? childForceExpandWidth : childForceExpandHeight))
                    flexible = Mathf.Max(flexible, 1);

                float requiredSpace = Mathf.Clamp(innerSize, min, flexible > 0 ? size : preferred);
                float startOffset = GetStartOffset(axis, requiredSpace);
                SetChildAlongAxis(child, axis, startOffset, requiredSpace);
            }
        }
        else
        {
            float pos = (axis == 0 ? padding.left : padding.top);
            if (GetTotalFlexibleSize(axis) == 0 && GetTotalPreferredSize(axis) < size)
                pos = GetStartOffset(axis, GetTotalPreferredSize(axis) - (axis == 0 ? padding.horizontal : padding.vertical));

            float minMaxLerp = 0;
            if (GetTotalMinSize(axis) != GetTotalPreferredSize(axis))
                minMaxLerp = Mathf.Clamp01((size - GetTotalMinSize(axis)) / (GetTotalPreferredSize(axis) - GetTotalMinSize(axis)));

            float itemFlexibleMultiplier = 0;
            if (size > GetTotalPreferredSize(axis))
            {
                if (GetTotalFlexibleSize(axis) > 0)
                    itemFlexibleMultiplier = (size - GetTotalPreferredSize(axis)) / GetTotalFlexibleSize(axis);
            }

            for (int i = 0; i < rectChildren.Count; i++)
            {
                RectTransform child = rectChildren[i];
                float min = LayoutUtility.GetMinSize(child, axis);
                float preferred = LayoutUtility.GetPreferredSize(child, axis);
                float flexible = LayoutUtility.GetFlexibleSize(child, axis);
                if ((axis == 0 ? childForceExpandWidth : childForceExpandHeight))
                    flexible = Mathf.Max(flexible, 1);

                float childSize = Mathf.Lerp(min, preferred, minMaxLerp);
                childSize += flexible * itemFlexibleMultiplier;
                SetChildAlongAxis(child, axis, pos, childSize);
                pos += childSize + spacing_;
            }
        }
    }
}
