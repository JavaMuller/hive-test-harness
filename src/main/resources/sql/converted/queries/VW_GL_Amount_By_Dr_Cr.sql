SELECT
    COA.ey_account_type ,
    COA.ey_account_sub_type ,
    COA.ey_account_class ,
    COA.ey_account_sub_class ,
    COA.gl_account_cd ,
    COA.gl_account_name ,
    COA.ey_account_group_I ,
    COA.ey_account_group_II ,
    COA.ey_gl_account_name ,
    FT_GL.[dr_cr_ind    ] ,
    ul.preparer_ref  AS [Preparer] ,
    ul.department    AS [Preparer department] ,
    SL.source_ref ,
    SL.source_group AS [Source GROUP] ,
    bu.bu_ref ,
    bu.bu_group ,
    SG1.ey_segment_group AS [Segment 1 GROUP] ,
    SG2.ey_segment_group AS [Segment 2 GROUP] ,
    SG1.ey_segment_ref   AS [Segment 1] ,
    SG2.ey_segment_ref   AS [Segment 2] ,
    FT_GL.year_flag ,
    FT_GL.period_flag ,
    CASE
        WHEN FT_GL.year_flag = 'CY'
        THEN 'Current'
        WHEN FT_GL.year_flag = 'PY'
        THEN 'Prior'
        WHEN FT_GL.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
                           END ,
    PP.period_flag_desc AS [Accounting sub period] ,
    FT_GL.ey_period     AS [Fiscal period] ,
    FT_GL.Sys_man_ind,
    FT_GL.journal_type ,
    FT_GL.reporting_amount_curr_cd ,
    FT_GL.functional_curr_cd ,
    SUM(FT_GL.net_amount) ,
    SUM(FT_GL.net_reporting_amount) ,
    SUM(FT_GL.net_reporting_amount_credit) ,
    SUM(FT_GL.net_reporting_amount_debit) ,
    SUM(FT_GL.net_functional_amount) ,
    SUM(FT_GL.net_functional_amount_credit) ,
    SUM(FT_GL.net_functional_amount_debit)
FROM
    dbo.FT_GL_Account FT_GL
INNER JOIN
    dbo.v_Chart_of_accounts COA
ON
    COA.coa_id = FT_GL.coa_id
AND COA.bu_id = FT_GL.bu_id
LEFT OUTER JOIN
    dbo.Parameters_period PP
ON
    PP.period_flag = FT_GL.period_flag
AND PP.year_flag = FT_GL.year_flag
LEFT OUTER JOIN
    dbo.v_User_listing ul
ON
    ul.user_listing_id = FT_GL.user_listing_id
LEFT OUTER JOIN
    dbo.v_Business_unit_listing bu
ON
    FT_GL.bu_id = bu.bu_id
LEFT OUTER JOIN
    dbo.v_Source_listing SL
ON
    FT_GL.source_id = SL.source_id
LEFT OUTER JOIN
    dbo.v_Segment01_listing SG1
ON
    SG1.ey_segment_id = FT_GL.segment1_id
LEFT OUTER JOIN
    dbo.v_Segment02_listing SG2
ON
    SG2.ey_segment_id = FT_GL.segment2_id
GROUP BY
    COA.ey_account_type ,
    COA.ey_account_sub_type ,
    COA.ey_account_class ,
    COA.ey_account_sub_class ,
    COA.gl_account_cd ,
    COA.gl_account_name ,
    COA.ey_account_group_I ,
    COA.ey_account_group_II ,
    COA.ey_gl_account_name ,
    FT_GL.[dr_cr_ind] ,
    UL.preparer_ref ,
    UL.department ,
    SL.source_ref ,
    SL.source_group ,
    bu.bu_ref ,
    bu.bu_group ,
    SG1.ey_segment_group ,
    SG2.ey_segment_group ,
    SG1.ey_segment_ref ,
    SG2.ey_segment_ref ,
    FT_GL.year_flag ,
    FT_GL.period_flag ,
    PP.year_flag_desc ,
    PP.period_flag_desc ,
    FT_GL.ey_period ,
    FT_GL.Sys_man_ind ,
    FT_GL.journal_type ,
    FT_GL.reporting_amount_curr_cd ,
    FT_GL.functional_curr_cd