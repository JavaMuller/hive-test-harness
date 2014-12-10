SELECT
    F.ey_period ,
    F.journal_type ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    src.source_group ,
    src.source_ref ,
    bu.bu_ref ,
    bu.bu_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    UL.preparer_ref ,
    UL.department ,
    AUL.preparer_ref ,
    AUL.department ,
    F.year_flag ,
    F.period_flag ,
    CASE
        WHEN F.year_flag ='CY'
        THEN 'Current'
        WHEN F.year_flag ='PY'
        THEN 'Prior'
        WHEN F.year_flag ='SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
    END ,
    PP.period_flag_desc ,
    F.reporting_amount_curr_cd ,
    F.functional_curr_cd ,
    SUM(F.net_reporting_amount_debit) ,
    SUM(F.net_reporting_amount_debit) ,
    ABS(SUM(F.net_reporting_amount_debit))+ABS(SUM(F.net_reporting_amount_debit)) ,
    ABS(SUM(F.net_functional_amount_credit))+ABS(SUM(F.net_functional_amount_debit))
FROM
    dbo.FT_GL_Account F
INNER JOIN
    dbo.Parameters_period PP
ON
    PP.year_flag = F.year_flag
AND PP.period_flag = F.period_flag
LEFT OUTER JOIN
    dbo.v_User_listing UL
ON
    UL.user_listing_id = F.user_listing_id
LEFT OUTER JOIN
    dbo.v_User_listing AUL
ON
    AUL.user_listing_id = F.approved_by_id
LEFT OUTER JOIN
    dbo.v_Business_unit_listing BU
ON
    Bu.bu_id = f.bu_id
LEFT OUTER JOIN
    dbo.v_Source_listing src
ON
    src.source_id = f.source_id
LEFT OUTER JOIN
    dbo.v_Segment01_listing S1
ON
    S1.ey_segment_id = f.segment1_id
LEFT OUTER JOIN
    dbo.v_Segment02_listing S2
ON
    S2.ey_segment_id = f.segment2_id
GROUP BY
    F.ey_period ,
    F.journal_type ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    src.source_group ,
    src.source_ref ,
    bu.bu_ref ,
    bu.bu_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    UL.preparer_ref ,
    UL.department ,
    AUL.preparer_ref ,
    AUL.department ,
    F.year_flag ,
    F.period_flag ,
    PP.year_flag_desc ,
    PP.period_flag_desc ,
    F.reporting_amount_curr_cd ,
    F.functional_curr_cd