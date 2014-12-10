SELECT
    fj.coa_id ,
    fj.ey_account_type ,
    fj.ey_account_sub_type ,
    fj.ey_account_class ,
    fj.ey_account_sub_class ,
    fj.gl_account_cd ,
    fj.gl_account_name ,
    fj.ey_gl_account_name ,
    fj.bu_id ,
    bu.bu_ref ,
    bu.bu_group ,
    fj.segment1_id ,
    s1.ey_segment_ref ,
    s1.ey_segment_group ,
    fj.segment2_id ,
    s2.ey_segment_ref ,
    s2.ey_segment_group ,
    fj.functional_curr_cd ,
    fj.reporting_amount_curr_cd ,
    fj.period_flag ,
    fj.year_flag ,
    CASE
        WHEN fj.year_flag = 'CY'
        THEN 'Current'
        WHEN fj.year_flag = 'PY'
        THEN 'Prior'
        WHEN fj.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE fj.year_flag_Desc
    END ,
    fj.period_flag_desc ,
    SUM(functional_amount) ,
    SUM(reporting_amount) ,
    fj.ver_end_date_id ,
    fj.ver_desc ,
    'Backposting activity'
FROM
    dbo.flat_je fj
LEFT OUTER JOIN
    dbo.v_Business_unit_listing BU
ON
    Bu.bu_id = fj.bu_id
LEFT OUTER JOIN
    dbo.v_Segment01_listing S1
ON
    S1.ey_segment_id = fj.segment1_id
LEFT OUTER JOIN
    dbo.v_Segment02_listing S2
ON
    S2.ey_segment_id = fj.segment2_id
WHERE
    fj.period_flag = 'IP'
AND fj.ver_end_date_id IS NULL
GROUP BY
    fj.coa_id ,
    fj.gl_account_cd ,
    fj.gl_account_name ,
    fj.ey_gl_account_name ,
    fj.bu_id ,
    bu.bu_ref ,
    bu.bu_group ,
    fj.segment1_id ,
    s1.ey_segment_ref ,
    s1.ey_segment_group ,
    fj.segment2_id ,
    s2.ey_segment_ref ,
    s2.ey_segment_group ,
    fj.functional_curr_cd ,
    fj.reporting_amount_curr_cd ,
    fj.period_flag ,
    fj.year_flag ,
    fj.year_flag_desc ,
    fj.ver_end_date_id ,
    fj.ver_desc ,
    fj.ey_account_type ,
    fj.ey_account_sub_type ,
    fj.ey_account_class ,
    fj.ey_account_sub_class ,
    period_flag_desc
UNION
SELECT
    tb.coa_id ,
    coa.ey_account_type ,
    coa.ey_account_sub_type ,
    coa.ey_account_class ,
    coa.ey_account_sub_class ,
    coa.gl_account_cd ,
    coa.gl_account_name ,
    coa.ey_gl_account_name ,
    tb.bu_id ,
    bu.bu_ref ,
    bu.bu_group ,
    tb.segment1_id ,
    s1.ey_segment_ref ,
    s1.ey_segment_group ,
    tb.segment2_id ,
    s2.ey_segment_ref ,
    s2.ey_segment_group ,
    tb.functional_curr_cd ,
    tb.reporting_curr_cd ,
    pp.period_flag ,
    pp.year_flag ,
    CASE
        WHEN pp.year_flag = 'CY'
        THEN 'Current'
        WHEN pp.year_flag = 'PY'
        THEN 'Prior'
        WHEN pp.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END ,
    pp.period_flag_desc ,
    tb.functional_beginning_balance + ag.net_functional_amount ,
    tb.reporting_beginning_balance +  ag.net_reporting_amount ,
    NULL ,
    NULL ,
    'Interim as posted'
FROM
    dbo.TrialBalance tb
FULL OUTER JOIN
    (
        SELECT
            fj.coa_id ,
            fj.gl_account_cd ,
            fj.gl_account_name ,
            fj.ey_gl_account_name ,
            fj.bu_id ,
            bu.bu_ref ,
            bu.bu_group ,
            fj.segment1_id ,
            s1.ey_segment_ref ,
            s1.ey_segment_group ,
            fj.segment2_id ,
            s2.ey_segment_ref ,
            s2.ey_segment_group ,
            fj.functional_curr_cd ,
            fj.reporting_amount_curr_cd ,
            fj.period_flag ,
            fj.year_flag ,
            fj.year_flag_desc ,
            fj.ver_end_date_id ,
            fj.ver_desc ,
            SUM(functional_amount) AS net_functional_amount ,
            SUM(reporting_amount)  AS net_reporting_amount
        FROM
            dbo.flat_je fj
        LEFT OUTER JOIN
            dbo.v_Business_unit_listing BU
        ON
            Bu.bu_id = fj.bu_id
        LEFT OUTER JOIN
            dbo.v_Segment01_listing S1
        ON
            S1.ey_segment_id = fj.segment1_id
        LEFT OUTER JOIN
            dbo.v_Segment02_listing S2
        ON
            S2.ey_segment_id = fj.segment2_id
        WHERE
            fj.period_flag = 'IP'
        AND fj.ver_end_date_id IS NULL
        GROUP BY
            fj.coa_id ,
            fj.gl_account_cd ,
            fj.gl_account_name ,
            fj.ey_gl_account_name ,
            fj.bu_id ,
            bu.bu_ref ,
            bu.bu_group ,
            fj.segment1_id ,
            s1.ey_segment_ref ,
            s1.ey_segment_group ,
            fj.segment2_id ,
            s2.ey_segment_ref ,
            s2.ey_segment_group ,
            fj.functional_curr_cd ,
            fj.reporting_amount_curr_cd ,
            fj.period_flag ,
            fj.year_flag ,
            fj.year_flag_desc ,
            fj.ver_end_date_id ,
            fj.ver_desc ) ag
ON
    ag.coa_id = tb.coa_id
AND ag.bu_id = tb.bu_id
INNER JOIN
    dbo.DIM_Chart_of_Accounts coa
ON
    coa.Coa_id = tb.coa_id
INNER JOIN
    dbo.Dim_Fiscal_calendar fc
ON
    tb.period_id = fc.period_id
INNER JOIN
    dbo.Parameters_period pp
ON
    fc.fiscal_period_seq = pp.fiscal_period_seq_end
AND fc.fiscal_year_cd = pp.fiscal_year_cd
LEFT OUTER JOIN
    dbo.v_Business_unit_listing BU
ON
    Bu.bu_id = tb.bu_id
LEFT OUTER JOIN
    dbo.v_Segment01_listing S1
ON
    S1.ey_segment_id = tb.segment1_id
LEFT OUTER JOIN
    dbo.v_Segment02_listing S2
ON
    S2.ey_segment_id = tb.segment2_id
WHERE
    pp.period_flag = 'IP'
AND tb.ver_end_date_id IS NULL
UNION
SELECT
    tb.coa_id ,
    coa.ey_account_type ,
    coa.ey_account_sub_type ,
    coa.ey_account_class ,
    coa.ey_account_sub_class ,
    coa.gl_account_cd ,
    coa.gl_account_name ,
    coa.ey_gl_account_name ,
    tb.bu_id ,
    bu.bu_ref ,
    bu.bu_group ,
    tb.segment1_id ,
    s1.ey_segment_ref ,
    s1.ey_segment_group ,
    tb.segment2_id ,
    s2.ey_segment_ref ,
    s2.ey_segment_group ,
    tb.functional_curr_cd ,
    tb.reporting_curr_cd ,
    pp.period_flag ,
    pp.year_flag ,
    CASE
        WHEN pp.year_flag = 'CY'
        THEN 'Current'
        WHEN pp.year_flag = 'PY'
        THEN 'Prior'
        WHEN pp.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END ,
    pp.period_flag_desc ,
    tb.functional_ending_balance ,
    tb.reporting_ending_balance ,
    NULL ,
    NULL ,
    'Interim as shown'
FROM
    dbo.TrialBalance tb
INNER JOIN
    dbo.DIM_Chart_of_Accounts coa
ON
    coa.Coa_id = tb.coa_id
INNER JOIN
    dbo.Dim_Fiscal_calendar fc
ON
    tb.period_id = fc.period_id
INNER JOIN
    dbo.Parameters_period pp
ON
    fc.fiscal_period_seq = pp.fiscal_period_seq_end
AND fc.fiscal_year_cd = pp.fiscal_year_cd
LEFT OUTER JOIN
    dbo.v_Business_unit_listing BU
ON
    Bu.bu_id = tb.bu_id
LEFT OUTER JOIN
    dbo.v_Segment01_listing S1
ON
    S1.ey_segment_id = tb.segment1_id
LEFT OUTER JOIN
    dbo.v_Segment02_listing S2
ON
    S2.ey_segment_id = tb.segment2_id
WHERE
    pp.period_flag = 'IP'
AND tb.ver_end_date_id IS NULL