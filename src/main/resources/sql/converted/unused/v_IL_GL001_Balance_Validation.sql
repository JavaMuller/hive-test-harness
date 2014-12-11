SELECT
    coa.ey_account_type ,
    bu.bu_ref ,
    bu.bu_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    pp.year_flag ,
    pp.period_flag ,
    CASE
        WHEN pp.year_flag = 'CY'
        THEN 'Current'
        WHEN pp.year_flag ='PY'
        THEN 'Prior'
        WHEN pp.year_flag ='SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END ,
    pp.period_flag_desc ,
    pp.fiscal_period_seq_end ,
    tb.reporting_curr_cd ,
    tb.functional_curr_cd ,
    SUM(tb.reporting_ending_balance) ,
    SUM(tb.functional_ending_balance)
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
INNER JOIN
    Parameters_period pp
ON
    fc.fiscal_period_seq = pp.fiscal_period_seq_end
AND fc.fiscal_year_cd = pp.fiscal_year_cd
LEFT OUTER JOIN
    v_Business_unit_listing Bu
ON
    bu.bu_id = tb.bu_id
LEFT OUTER JOIN
    v_Segment01_listing S1
ON
    s1.ey_segment_id = tb.segment1_id
LEFT OUTER JOIN
    v_Segment02_listing s2
ON
    s2.ey_segment_id = tb.segment2_id
WHERE
    tb.ver_end_date_id IS NULL
GROUP BY
    coa.ey_account_type ,
    bu.bu_ref ,
    bu.bu_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    pp.year_flag ,
    pp.period_flag ,
    pp.year_flag_desc ,
    pp.period_flag_desc ,
    pp.fiscal_period_seq_end ,
    tb.reporting_curr_cd ,
    tb.functional_curr_cd