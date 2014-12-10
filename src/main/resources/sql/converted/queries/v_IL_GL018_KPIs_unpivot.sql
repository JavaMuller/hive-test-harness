SELECT
    Source_ID,
    Source_Cd,
    Source_Desc preparer_ref,
    Preparer_Name,
    Preparer_department,
    Source_group,
    Source_Ref Journal_Type,
    Segment1_Group,
    Segment2_Group,
    Segment1_ref,
    Segment2_ref,
    bu_ref,
    bu_group,
    Year_flag_desc,
    period_flag_desc,
    ey_period,
    Ratio_type,
    Ratio,
    Amount,
    Multiplier
FROM
    GL_018_KPIs_unpivot