SELECT
    C.ey_account_type,
    C.ey_account_sub_type,
    C.ey_account_class,
    C.ey_account_sub_class,
    C.gl_account_name,
    C.gl_account_cd,
    C.ey_gl_account_name,
    C.ey_account_group_I,
    F.year_flag,
    F.period_flag,
    CASE
    WHEN pp.year_flag = 'CY'
    THEN 'Current'
    WHEN pp.year_flag = 'PY'
    THEN 'Prior'
    WHEN pp.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE pp.year_flag_desc
    END,
    pp.period_flag_desc,
    F.ey_period,
    Dp.preparer_ref,
    Dp.department,
    Dp1.department,
    Dp1.preparer_ref,
    Src.source_ref,
    src.source_group,
    s1.ey_segment_ref,
    S1.ey_segment_group,
    s2.ey_segment_ref,
    S2.ey_segment_group,
    Bu.bu_group,
    Bu.bu_ref,
    F.journal_type,
    F.reporting_amount_curr_cd,
    F.functional_curr_cd,
    SUM(F.Net_reporting_amount),
    SUM(
        CASE
        WHEN c.ey_account_type = 'Revenue'
        THEN F.Net_reporting_amount
        ELSE 0
        END),
    SUM(
        CASE
        WHEN c.ey_account_sub_type = 'Cost of sales'
        THEN F.Net_reporting_amount
        ELSE 0
        END),
    SUM(F.Net_reporting_amount_credit),
    SUM(F.Net_reporting_amount_debit),
    SUM(F.Net_functional_amount),
    SUM(
        CASE
        WHEN c.ey_account_type = 'Revenue'
        THEN F.Net_functional_amount
        ELSE 0
        END),
    SUM(
        CASE
        WHEN c.ey_account_sub_type = 'Cost of sales'
        THEN F.Net_functional_amount
        ELSE 0
        END),
    SUM(F.Net_functional_amount_credit),
    SUM(F.Net_functional_amount_debit)
FROM
    FT_GL_Account F
    INNER JOIN
    Dim_Chart_of_Accounts C
        ON
            F.coa_id = C.coa_id
    INNER JOIN
    Dim_Preparer Dp
        ON
            Dp.user_listing_id = F.user_listing_id
    INNER JOIN
    Dim_Preparer Dp1
        ON
            Dp1.user_listing_id = F.approved_by_id
    INNER JOIN
    Parameters_period PP
        ON
            pp.year_flag = F.year_flag
            AND pp.period_flag = F.period_flag
    LEFT OUTER JOIN
    v_Business_unit_listing BU
        ON
            Bu.bu_id = f.bu_id
    LEFT OUTER JOIN
    v_Source_listing src
        ON
            src.source_id = f.source_id
    LEFT OUTER JOIN
    v_Segment01_listing S1
        ON
            S1.ey_segment_id = f.segment1_id
    LEFT OUTER JOIN
    v_Segment02_listing S2
        ON
            S2.ey_segment_id = f.segment2_id
GROUP BY
    C.ey_account_type,
    C.ey_account_sub_type,
    C.ey_account_class,
    C.ey_account_sub_class,
    C.gl_account_name,
    C.gl_account_cd,
    C.ey_gl_account_name,
    C.ey_account_group_I,
    F.year_flag,
    F.period_flag,
    pp.year_flag_desc,
    pp.period_flag_desc,
    F.ey_period,
    Dp.preparer_ref,
    Dp.department,
    Dp1.department,
    Dp1.preparer_ref,
    Src.source_ref,
    src.source_group,
    S1.ey_segment_group,
    S2.ey_segment_group,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    Bu.bu_group,
    Bu.bu_ref,
    f.journal_type,
    F.reporting_amount_curr_cd,
    F.functional_curr_cd,
    pp.year_flag;