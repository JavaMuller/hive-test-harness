
SELECT DISTINCT
    JE.EY_period ,
    JE.year_flag ,
    JE.period_flag ,
    BU.[bu_ref  ] ,
    BU.[bu_group] ,
    CASE
        WHEN PP.year_flag ='CY'
        THEN 'Current'
        WHEN PP.year_flag ='PY'
        THEN 'Prior'
        WHEN PP.year_flag ='SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
    END ,
    PP.period_flag_desc ,
    PRP.preparer_ref ,
    PRP.department ,
    ARP.preparer_ref ,
    ARP.department ,
    SL1.[ey_segment_group] ,
    SL1.[ey_segment_ref  ] ,
    SL2.[ey_segment_group] ,
    SL2.[ey_segment_ref  ] ,
    SL.source_ref ,
    SL.source_group ,
    JE.journal_type ,
    JE.reporting_amount_curr_cd ,
    JE.functional_curr_cd ,
    COA.ey_account_group_I ,
    COA.ey_account_type ,
    COA.ey_account_sub_type ,
    COA.ey_account_class ,
    COA.ey_account_sub_class ,
    COA.gl_account_cd ,
    COA.gl_account_name ,
    COA.ey_gl_account_name
FROM
    dbo.FT_GL_Account JE
LEFT OUTER JOIN
    dbo.v_Business_unit_listing BU
ON
    JE.bu_id = BU.bu_id
LEFT OUTER JOIN
    [Parameters_period] PP
ON
    JE.period_flag = PP.period_flag
LEFT OUTER JOIN
    dbo.v_User_listing PRP
ON
    JE.user_listing_id = PRP.user_listing_id
LEFT OUTER JOIN
    dbo.v_User_listing ARP
ON
    JE.approved_by_id = ARP.user_listing_id
LEFT OUTER JOIN
    [v_Segment01_listing] SL1
ON
    JE.segment1_id = SL1.ey_segment_id
LEFT OUTER JOIN
    [v_Segment02_listing] SL2
ON
    JE.segment2_id = SL2.ey_segment_id
LEFT OUTER JOIN
    v_Source_listing SL
ON
    JE.source_id = SL.source_id
LEFT OUTER JOIN
    v_Chart_of_accounts COA
ON
    JE.coa_id = COA.coa_id