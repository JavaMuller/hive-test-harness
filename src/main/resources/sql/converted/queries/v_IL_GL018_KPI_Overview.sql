SELECT
    coa.ey_account_type AS `Category`,
    fj.ey_period AS `Fiscal period`,
    CASE
    WHEN fj.year_flag = 'CY'
    THEN 'Current'
    WHEN fj.year_flag = 'PY'
    THEN 'Prior'
    WHEN fj.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE PP.year_flag_desc
    END AS `Accounting period`,
    PP.period_flag_desc AS `Accounting sub period`,
    fj.year_flag AS `Year flag`,
    fj.period_flag AS `Period flag`,
    bu.bu_group AS `Business unit group`,
    bu.bu_ref AS `Business Unit`,
    s1.ey_segment_ref AS `Segment 1`,
    s2.ey_segment_ref AS `Segment 2`,
    s1.ey_segment_group AS `Segment 1 group`,
    s2.ey_segment_group AS `Segment 2 group`,
    fj.reporting_amount_curr_cd AS `Reporting currency code`,
    fj.functional_curr_cd AS `Functional currency code`,
    ROUND(SUM(fj.net_reporting_amount), 2) AS `Net reporting amount`,
    ROUND(SUM(fj.net_functional_amount), 2) AS `Net functional amount`,
    'Activity' AS `Source Type`,
    pp.end_date AS `Period end date`,
    NULL AS `Fiscal period sequence`,
    NULL AS `Fiscal period sequence end`,
    NULL AS `Adjustment period`
FROM
    FT_GL_Account FJ
    INNER JOIN
    Parameters_period PP
        ON
            pp.period_flag = fj.period_flag
            AND PP.year_flag = FJ.year_flag
    INNER JOIN
    v_Chart_of_accounts coa
        ON
            coa.coa_id = fj.coa_id
            AND coa.bu_id = FJ.bu_id
    LEFT OUTER JOIN
    v_Business_unit_listing bu
        ON
            bu.bu_id = fj.bu_id
    LEFT OUTER JOIN
    v_Segment01_listing s1
        ON
            s1.ey_segment_id = Fj.segment1_id
    LEFT OUTER JOIN
    v_Segment02_listing s2
        ON
            s2.ey_segment_id = Fj.segment2_id
WHERE
    fj.year_flag IN ('CY',
                     'PY')
GROUP BY
    coa.ey_account_type,
    fj.ey_period,
    fj.year_flag,
    pp.year_flag_desc,
    pp.period_flag_desc,
    fj.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    fj.reporting_amount_curr_cd,
    fj.functional_curr_cd,
    PP.end_date
UNION ALL
SELECT
    coa.ey_account_sub_type AS `Category`,
    fj.ey_period AS `Fiscal period`,
    CASE
    WHEN fj.year_flag = 'CY'
    THEN 'Current'
    WHEN fj.year_flag = 'PY'
    THEN 'Prior'
    WHEN fj.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE pp.year_flag_desc
    END AS `Accounting period`,
    PP.period_flag_desc AS `Accounting sub period`,
    fj.year_flag AS `Year flag`,
    fj.period_flag AS `Period flag`,
    bu.bu_group AS `Business unit group`,
    bu.bu_ref AS `Business Unit`,
    s1.ey_segment_ref AS `Segment 1`,
    s2.ey_segment_ref AS `Segment 2`,
    s1.ey_segment_group AS `Segment 1 group`,
    s2.ey_segment_group AS `Segment 2 group`,
    fj.reporting_amount_curr_cd AS `Reporting currency code`,
    fj.functional_curr_cd AS `Functional currency code`,
    ROUND(SUM(fj.net_reporting_amount), 2) AS `Net reporting amount`,
    ROUND(SUM(fj.net_functional_amount), 2) AS `Net functional amount`,
    'Activity' AS `Source Type`,
    pp.end_date AS `Period end date`,
    NULL AS `Fiscal period sequence`,
    NULL AS `Fiscal period sequence end`,
    NULL AS `Adjustment period`
FROM
    FT_GL_Account FJ
    INNER JOIN
    Parameters_period PP
        ON
            pp.period_flag = fj.period_flag
            AND PP.year_flag = FJ.year_flag
    INNER JOIN
    v_Chart_of_accounts coa
        ON
            coa.coa_id = fj.coa_id
            AND coa.bu_id = FJ.bu_id
    LEFT OUTER JOIN
    v_Business_unit_listing bu
        ON
            bu.bu_id = fj.bu_id
    LEFT OUTER JOIN
    v_Segment01_listing s1
        ON
            s1.ey_segment_id = Fj.segment1_id
    LEFT OUTER JOIN
    v_Segment02_listing s2
        ON
            s2.ey_segment_id = Fj.segment2_id
WHERE
    fj.year_flag IN ('CY',
                     'PY')
GROUP BY
    coa.ey_account_sub_type,
    fj.ey_period,
    fj.year_flag,
    fj.period_flag,
    pp.year_flag_desc,
    PP.period_flag_desc,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    fj.reporting_amount_curr_cd,
    fj.functional_curr_cd,
    pp.end_date
UNION ALL
SELECT
    coa.ey_account_group_I AS `Category`,
    fj.ey_period AS `Fiscal period`,
    CASE
    WHEN fj.year_flag = 'CY'
    THEN 'Current'
    WHEN fj.year_flag = 'PY'
    THEN 'Prior'
    WHEN fj.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE PP.year_flag_desc
    END AS `Accounting period`,
    PP.period_flag_desc AS `Accounting sub period`,
    fj.year_flag AS `Year flag`,
    fj.period_flag AS `Period flag`,
    bu.bu_group AS `Business unit group`,
    bu.bu_ref AS `Business Unit`,
    s1.ey_segment_ref AS `Segment 1`,
    s2.ey_segment_ref AS `Segment 2`,
    s1.ey_segment_group AS `Segment 1 group`,
    s2.ey_segment_group AS `Segment 2 group`,
    fj.reporting_amount_curr_cd AS `Reporting currency code`,
    fj.functional_curr_cd AS `Functional currency code`,
    ROUND(SUM(fj.net_reporting_amount), 2) AS `Net reporting amount`,
    ROUND(SUM(fj.net_functional_amount), 2) AS `Net functional amount`,
    'Activity' AS `Source Type`,
    pp.end_date AS `Period end date`,
    NULL AS `Fiscal period sequence`,
    NULL AS `Fiscal period sequence end`,
    NULL AS `Adjustment period`
FROM
    FT_GL_Account FJ
    INNER JOIN
    Parameters_period PP
        ON
            pp.period_flag = fj.period_flag
            AND PP.year_flag = FJ.year_flag
    INNER JOIN
    v_Chart_of_accounts coa
        ON
            coa.coa_id = fj.coa_id
            AND coa.bu_id = FJ.bu_id
    LEFT OUTER JOIN
    v_Business_unit_listing bu
        ON
            bu.bu_id = fj.bu_id
    LEFT OUTER JOIN
    v_Segment01_listing s1
        ON
            s1.ey_segment_id = Fj.segment1_id
    LEFT OUTER JOIN
    v_Segment02_listing s2
        ON
            s2.ey_segment_id = Fj.segment2_id
WHERE
    fj.year_flag IN ('CY',
                     'PY')
GROUP BY
    coa.ey_account_group_I,
    fj.ey_period,
    fj.year_flag,
    pp.year_flag_desc,
    PP.period_flag_desc,
    fj.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    fj.reporting_amount_curr_cd,
    fj.functional_curr_cd,
    pp.end_date
UNION ALL
SELECT
    coa.ey_account_type AS `Category`,
    fc.fiscal_period_cd AS `Fiscal period`,
    CASE
    WHEN pp.year_flag = 'CY'
    THEN 'Current'
    WHEN pp.year_flag = 'PY'
    THEN 'Prior'
    WHEN pp.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE pp.year_flag_desc
    END AS `Accounting period`,
    pp.period_flag_desc AS `Accounting sub period`,
    pp.year_flag AS `Year flag`,
    pp.period_flag AS `Period flag`,
    bu.bu_group AS `Business unit group`,
    bu.bu_ref AS `Business Unit`,
    s1.ey_segment_ref AS `Segment 1`,
    s2.ey_segment_ref AS `Segment 2`,
    s1.ey_segment_group AS `Segment 1 group`,
    s2.ey_segment_group AS `Segment 2 group`,
    tb.reporting_curr_cd AS `Reporting currency code`,
    tb.functional_curr_cd AS `Functional currency code`,
    ROUND(SUM(tb.reporting_ending_balance), 2) AS `Net reporting amount`,
    ROUND(SUM(tb.functional_ending_balance), 2) AS `Net functional amount`,
    'Balance' AS `Source Type`,
    pp.END_date AS `Period end date`,
    fc.fiscal_period_seq AS `Fiscal period sequence`,
    pp.fiscal_period_seq_END AS `Fiscal period sequence end`,
    fc.adjustment_period AS `Adjustment period`
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
            fc.fiscal_year_cd = pp.fiscal_year_cd
    LEFT OUTER JOIN
    v_Business_unit_listing bu
        ON
            bu.bu_id = tb.bu_id
    LEFT OUTER JOIN
    v_Segment01_listing S1
        ON
            s1.ey_segment_id = tb.segment1_id
    LEFT OUTER JOIN
    v_Segment02_listing S2
        ON
            s2.ey_segment_id = tb.segment2_id
WHERE
    pp.year_flag IN ('CY',
                     'PY')
    AND tb.ver_end_date_id IS NULL
GROUP BY
    coa.ey_account_type,
    fc.fiscal_period_cd,
    pp.year_flag,
    pp.year_flag_desc,
    pp.period_flag_desc,
    pp.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    tb.reporting_curr_cd,
    tb.functional_curr_cd,
    pp.END_date,
    fc.fiscal_period_seq,
    pp.fiscal_period_seq_END,
    fc.adjustment_period
UNION ALL
SELECT
    coa.ey_account_sub_type AS `Category`,
    fc.fiscal_period_cd AS `Fiscal period`,
    CASE
    WHEN pp.year_flag = 'CY'
    THEN 'Current'
    WHEN pp.year_flag = 'PY'
    THEN 'Prior'
    WHEN pp.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE pp.year_flag_desc
    END AS `Accounting period`,
    pp.period_flag_desc AS `Accounting sub period`,
    pp.year_flag AS `Year flag`,
    pp.period_flag AS `Period flag`,
    bu.bu_group AS `Business unit group`,
    bu.bu_ref AS `Business Unit`,
    s1.ey_segment_ref AS `Segment 1`,
    s2.ey_segment_ref AS `Segment 2`,
    s1.ey_segment_group AS `Segment 1 group`,
    s2.ey_segment_group AS `Segment 2 group`,
    tb.reporting_curr_cd AS `Reporting currency code`,
    tb.functional_curr_cd AS `Functional currency code`,
    ROUND(SUM(tb.reporting_ending_balance), 2) AS `Net reporting amount`,
    ROUND(SUM(tb.functional_ending_balance), 2) AS `Net functional amount`,
    'Balance' AS `Source Type`,
    pp.END_date AS `Period end date`,
    fc.fiscal_period_seq AS `Fiscal period sequence`,
    pp.fiscal_period_seq_END AS `Fiscal period sequence end`,
    fc.adjustment_period AS `Adjustment period`
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
            fc.fiscal_year_cd = pp.fiscal_year_cd
    LEFT OUTER JOIN
    v_Business_unit_listing bu
        ON
            bu.bu_id = tb.bu_id
    LEFT OUTER JOIN
    v_Segment01_listing S1
        ON
            s1.ey_segment_id = tb.segment1_id
    LEFT OUTER JOIN
    v_Segment02_listing S2
        ON
            s2.ey_segment_id = tb.segment2_id
WHERE
    pp.year_flag IN ('CY',
                     'PY')
    AND tb.ver_end_date_id IS NULL
GROUP BY
    coa.ey_account_sub_type,
    fc.fiscal_period_cd,
    pp.year_flag,
    pp.year_flag_desc,
    pp.period_flag_desc,
    pp.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    tb.reporting_curr_cd,
    tb.functional_curr_cd,
    pp.END_date,
    fc.fiscal_period_seq,
    pp.fiscal_period_seq_END,
    fc.adjustment_period
UNION ALL
SELECT
    coa.ey_account_group_I AS `Category`,
    fc.fiscal_period_cd AS `Fiscal period`,
    CASE
    WHEN pp.year_flag = 'CY'
    THEN 'Current'
    WHEN pp.year_flag = 'PY'
    THEN 'Prior'
    WHEN pp.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE pp.year_flag_desc
    END AS `Accounting period`,
    pp.period_flag_desc AS `Accounting sub period`,
    pp.year_flag AS `Year flag`,
    pp.period_flag AS `Period flag`,
    bu.bu_group AS `Business unit group`,
    bu.bu_ref AS `Business Unit`,
    s1.ey_segment_ref AS `Segment 1`,
    s2.ey_segment_ref AS `Segment 2`,
    s1.ey_segment_group AS `Segment 1 group`,
    s2.ey_segment_group AS `Segment 2 group`,
    tb.reporting_curr_cd AS `Reporting currency code`,
    tb.functional_curr_cd AS `Functional currency code`,
    ROUND(SUM(tb.reporting_ending_balance), 2) AS `Net reporting amount`,
    ROUND(SUM(tb.functional_ending_balance), 2) AS `Net functional amount`,
    'Balance' AS `Source Type`,
    pp.END_date AS `Period end date`,
    fc.fiscal_period_seq AS `Fiscal period sequence`,
    pp.fiscal_period_seq_END AS `Fiscal period sequence end`,
    fc.adjustment_period AS `Adjustment period`
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
            fc.fiscal_year_cd = pp.fiscal_year_cd
    LEFT OUTER JOIN
    v_Business_unit_listing bu
        ON
            bu.bu_id = tb.bu_id
    LEFT OUTER JOIN
    v_Segment01_listing S1
        ON
            s1.ey_segment_id = tb.segment1_id
    LEFT OUTER JOIN
    v_Segment02_listing S2
        ON
            s2.ey_segment_id = tb.segment2_id
WHERE
    pp.year_flag IN ('CY',
                     'PY')
    AND tb.ver_end_date_id IS NULL
GROUP BY
    coa.ey_account_group_I,
    fc.fiscal_period_cd,
    pp.year_flag,
    pp.year_flag_desc,
    pp.period_flag_desc,
    pp.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    tb.reporting_curr_cd,
    tb.functional_curr_cd,
    pp.END_date,
    fc.fiscal_period_seq,
    pp.fiscal_period_seq_END,
    fc.adjustment_period;
