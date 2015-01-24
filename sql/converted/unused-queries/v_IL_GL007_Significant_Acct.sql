SELECT
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    coa.ey_account_class ,
    coa.ey_account_sub_class ,
    coa.gl_account_cd ,
    coa.gl_account_name ,
    coa.ey_account_type ,
    coa.ey_account_sub_type ,
    coa.ey_gl_account_name ,
    coa.ey_account_group_I ,
    bu.bu_ref ,
    bu.bu_group ,
    CASE
        WHEN FJ.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE src.source_group
    END ,
    CASE
        WHEN FJ.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE src.source_ref
    END ,
    CASE
        WHEN FJ.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE UL.preparer_ref
    END ,
    CASE
        WHEN FJ.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE UL.department
    END ,
    CASE
        WHEN FJ.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE AUL.department
    END ,
    CASE
        WHEN FJ.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE AUL.preparer_ref
    END ,
    CASE
        WHEN FJ.year_flag = 'CY'
        THEN 'Current'
        WHEN FJ.year_flag = 'PY'
        THEN 'Prior'
        WHEN FJ.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
    END ,
    PP.period_flag_desc ,
    fj.year_flag ,
    fj.period_flag ,
    FJ.EY_period ,
    fj.journal_type ,
    fj.reporting_curr_cd ,
    fj.functional_curr_cd ,
    source_type ,
    current_amount ,
    prior_amount ,
    count_of_je_line_items ,
    count_of_manual_je_lines ,
    manual_amount ,
    manual_functional_amount ,
    count_ofdistinct_preparers ,
    total_debit_activity ,
    largest_line_item ,
    largest_functional_line_item ,
    total_credit_activity ,
    net_reporting_amount ,
    net_reporting_amount_credit ,
    net_reporting_amount_debit ,
    net_functional_amount ,
    net_functional_amount_credit ,
    net_functional_amount_debit ,
    functional_ending_balance ,
    reporting_ending_balance ,
    net_functional_amount_current ,
    net_functional_amount_prior ,
    net_reporting_amount_current ,
    net_reporting_amount_prior
FROM
    GL_007_Significant_Acct FJ
INNER JOIN
    v_Chart_of_accounts coa
ON
    coa.coa_id = fj.coa_id
AND coa.bu_id = fj.bu_id
LEFT OUTER JOIN
    Parameters_period pp
ON
    pp.year_flag = fj.year_flag
AND PP.period_flag = fj.period_flag
LEFT OUTER JOIN
    v_User_listing UL
ON
    UL.user_listing_id = fj.user_listing_id
LEFT OUTER JOIN
    v_User_listing AUL
ON
    AUL.user_listing_id = FJ.approved_by_id
LEFT OUTER JOIN
    v_Business_unit_listing BU
ON
    Bu.bu_id = fj.bu_id
LEFT OUTER JOIN
    v_Source_listing src
ON
    src.source_id = fj.source_id
LEFT OUTER JOIN
    v_Segment01_listing S1
ON
    S1.ey_segment_id = fj.segment1_id
LEFT OUTER JOIN
    v_Segment02_listing S2
ON
    S2.ey_segment_id = fj.segment2_id