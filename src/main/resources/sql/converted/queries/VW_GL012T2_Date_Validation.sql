SELECT
    DV.COA_ID ,
    DV.year_flag ,
    DV.period_flag ,
    CASE
        WHEN DV.year_flag ='CY'
        THEN 'Current'
        WHEN DV.year_flag ='PY'
        THEN 'Prior'
        WHEN DV.year_flag ='SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END ,
    pp.Period_flag_desc ,
    DV.ey_period ,
    DV.entry_date ,
    DV.Effective_date ,
    DV.min_max_ent_eff_date ,
    DV.category ,
    DV.je_id_count ,
    DV.days_lag ,
    0 ,
    src.Source_ref ,
    src.Source_group ,
    UL.Preparer_ref ,
    UL.department ,
    coa.gl_Account_cd ,
    coa.ey_gl_account_name ,
    coa.ey_account_type ,
    coa.ey_account_sub_type ,
    coa.ey_account_class ,
    coa.ey_account_sub_class ,
    coa.ey_account_group_I ,
    bu.bu_ref ,
    bu.bu_group ,
    DV.journal_type ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    AUL.department ,
    AUL.preparer_ref ,
    DV.functional_curr_cd ,
    DV.reporting_amount_curr_cd ,
    DV.net_reporting_amount ,
    DV.net_reporting_amount_credit ,
    DV.net_reporting_amount_debit ,
    DV.net_functional_amount ,
    DV.net_functional_credit_amount ,
    DV.net_functional_debit_amount
FROM
    [GL_012_Date_Validation] DV
INNER JOIN
    v_Chart_of_accounts coa
ON
    COA.coa_id = DV.coa_id
INNER JOIN
    Parameters_period PP
ON
    PP.period_flag = DV.period_flag
AND PP.year_flag = dv.year_flag
LEFT OUTER JOIN
    v_User_listing UL
ON
    UL.user_listing_id = dv.user_listing_id
LEFT OUTER JOIN
    v_User_listing AUL
ON
    AUL.user_listing_id = dv.approver_by_id
LEFT OUTER JOIN
    v_Business_unit_listing BU
ON
    Bu.bu_id = DV.bu_id
LEFT OUTER JOIN
    v_Source_listing src
ON
    src.source_id = DV.source_id
LEFT OUTER JOIN
    v_Segment01_listing S1
ON
    S1.ey_segment_id = DV.segment1_id
LEFT OUTER JOIN
    v_Segment02_listing S2
ON
    S2.ey_segment_id = DV.segment2_id;