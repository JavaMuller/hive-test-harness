SELECT
    CASE
        WHEN f.year_flag ='CY'
        THEN 'Current'
        WHEN f.year_flag ='PY'
        THEN 'Prior'
        WHEN f.year_flag ='SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END ,
    PP.Period_flag_desc ,
    F.year_flag ,
    F.period_flag ,
    F.ey_period ,
    C.ey_account_type ,
    C.ey_account_sub_type ,
    C.ey_account_class ,
    C.ey_account_sub_class ,
    C.gl_account_name ,
    C.gl_account_cd ,
    C.ey_gl_account_name ,
    c.ey_account_group_I ,
    Dp.preparer_ref ,
    DP.department ,
    DP1.department ,
    DP1.preparer_ref ,
    B.bu_group ,
    b.bu_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    src.source_group ,
    src.source_Ref ,
    f.journal_type ,
    f.reporting_amount_curr_cd ,
    f.functional_curr_cd AS [Functional currency code] ,
    SUM(f.Net_reporting_amount) ,
    SUM(f.Net_reporting_amount_credit) ,
    SUM(f.Net_reporting_amount_debit) ,
    SUM(f.Net_functional_amount) ,
    SUM(f.Net_functional_amount_credit) ,
    SUM(f.Net_functional_amount_debit) ,
    'Activity' ,
    NULL ,
    NULL ,
    NULL
FROM
    FT_GL_Account F
INNER JOIN
    Parameters_period PP
ON
    PP.year_flag = f.year_flag
AND PP.period_flag = f.period_flag
INNER JOIN
    Dim_Preparer DP
ON
    DP.user_listing_id = f.user_listing_id
LEFT OUTER JOIN
    Dim_Preparer DP1
ON
    DP1.user_listing_id = f.approved_by_id
LEFT OUTER JOIN
    v_Business_unit_listing B
ON
    B.bu_id = F.bu_id
LEFT OUTER JOIN
    v_Segment01_listing S1
ON
    s1.ey_segment_id = f.segment1_id
LEFT OUTER JOIN
    v_Segment02_listing S2
ON
    s2.ey_segment_id = f.segment2_id
LEFT OUTER JOIN
    v_Source_listing Src
ON
    Src.Source_Id = f.source_id
INNER JOIN
    DIM_Chart_of_Accounts C
ON
    c.Coa_id = f.coa_id
GROUP BY
    PP.year_flag_desc ,
    PP.Period_flag_desc ,
    F.year_flag ,
    F.period_flag ,
    F.ey_period ,
    C.ey_account_type ,
    C.ey_account_sub_type ,
    C.ey_account_class ,
    C.ey_account_sub_class ,
    C.gl_account_name ,
    C.gl_account_cd ,
    C.ey_gl_account_name ,
    c.ey_account_group_I ,
    Dp.preparer_ref ,
    DP.department ,
    DP1.department ,
    DP1.preparer_ref ,
    B.bu_group ,
    b.bu_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    src.source_group ,
    src.source_Ref ,
    f.journal_type ,
    f.reporting_amount_curr_cd ,
    f.functional_curr_cd
UNION
SELECT
    CASE
        WHEN pp.year_flag ='CY'
        THEN 'Current'
        WHEN pp.year_flag ='PY'
        THEN 'Prior'
        WHEN pp.year_flag ='SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END ,
    pp.Period_flag_desc ,
    pp.year_flag ,
    pp.period_flag ,
    fc.fiscal_period_cd ,
    coa.ey_account_type ,
    coa.ey_account_sub_type ,
    coa.ey_account_class ,
    coa.ey_account_sub_class ,
    coa.gl_account_name ,
    coa.gl_account_cd ,
    coa.ey_gl_account_name ,
    coa.ey_account_group_I ,
    'N/A for balances' ,
    'N/A for balances' ,
    'N/A for balances' ,
    'N/A for balances' ,
    bu.bu_group ,
    bu.bu_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    'N/A for balances' ,
    'N/A for balances' ,
    'N/A for balances' ,
    tb.reporting_curr_cd ,
    tb.functional_curr_cd AS [Functional currency code] ,
    tb.reporting_ending_balance ,
    0.0 ,
    0.0 ,
    tb.functional_ending_balance ,
    0.0 ,
    0.0 ,
    'Balance' ,
    pp.end_date ,
    fc.fiscal_period_seq ,
    pp.fiscal_period_seq_END
FROM
    TrialBalance tb
INNER JOIN
    DIM_Chart_of_Accounts coa
ON
    coa.Coa_id = tb.coa_id
INNER JOIN
    Dim_Fiscal_calendar fc
ON
    tb.period_id = fc.period_id
AND tb.bu_id = fc.bu_id
INNER JOIN
    Parameters_period pp
ON
    fc.fiscal_year_cd = pp.fiscal_year_cd
LEFT OUTER JOIN
    v_Business_unit_listing Bu
ON
    Bu.bu_id = tb.bu_id
LEFT OUTER JOIN
    v_Segment01_listing S1
ON
    s1.ey_segment_id = tb.segment1_id
LEFT OUTER JOIN
    v_Segment02_listing S2
ON
    s2.ey_segment_id = tb.segment2_id
WHERE
    tb.ver_end_date_id IS NULL
AND ( ( (
                pp.period_flag = 'IP'
            OR  pp.period_flag = 'PIP') )
    OR  ( (
                pp.period_flag = 'RP'
            OR  pp.period_flag = 'PRP') )
    OR  (
            pp.period_flag = 'SP') )