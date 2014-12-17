SELECT DISTINCT *
FROM (
  SELECT
    coa.ey_account_type,
    coa.ey_account_class,
    coa.ey_account_group_I,
    f.ey_period,
    CASE
    WHEN f.year_flag = 'CY'
    THEN 'Current'
    WHEN f.year_flag = 'PY'
    THEN 'Prior'
    WHEN f.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE PP.year_flag_desc
    END,
    PP.period_flag_desc,
    f.year_flag,
    f.period_flag,
    bu.bu_group,
    bu.bu_ref,
    ul.preparer_ref,
    ul.department,
    aul.department,
    aul.preparer_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    src.source_ref,
    f.journal_type,
    f.reporting_amount_curr_cd,
    f.functional_curr_cd,
    ROUND(SUM(f.net_reporting_amount), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN f.net_reporting_amount
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN f.net_reporting_amount
                                   ELSE 0
                                   END), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN f.net_reporting_amount
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN f.net_reporting_amount
                                   ELSE 0
                                   END), 2),
    ROUND(SUM(f.net_functional_amount), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN f.net_functional_amount
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN f.net_functional_amount
                                   ELSE 0
                                   END), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN f.net_functional_amount
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN f.net_functional_amount
                                   ELSE 0
                                   END), 2),
    'Activity'
  FROM
    FT_GL_Account F
    INNER JOIN
    v_Chart_of_accounts coa
      ON
        coa.coa_id = F.coa_id
        AND coa.bu_id = f.bu_id
    INNER JOIN
    Parameters_period PP
      ON
        pp.year_flag = f.year_flag
        AND PP.period_flag = F.period_flag
    LEFT OUTER JOIN
    v_User_listing UL
      ON
        UL.user_listing_id = F.user_listing_id
    LEFT OUTER JOIN
    v_User_listing AUL
      ON
        AUL.user_listing_id = F.approved_by_id
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
  WHERE
    f.year_flag IN ('CY',
                    'PY')
  GROUP BY
    coa.ey_account_type,
    coa.ey_account_class,
    f.ey_period,
    PP.year_flag_desc,
    PP.period_flag_desc,
    f.year_flag,
    f.period_flag,
    bu.bu_group,
    bu.bu_ref,
    UL.preparer_ref,
    UL.department,
    AUL.department,
    AUL.preparer_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    src.source_ref,
    f.journal_type,
    COA.ey_account_group_I,
    f.reporting_amount_curr_cd,
    f.functional_curr_cd
  UNION ALL
  SELECT
    coa.ey_account_type,
    coa.ey_account_class,
    coa.ey_account_group_I,
    fc.fiscal_period_cd,
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
    pp.year_flag,
    pp.period_flag,
    bu.bu_group,
    bu.bu_ref,
    'N/A for balances',
    'N/A for balances',
    'N/A for balances',
    'N/A for balances',
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    'N/A for balances',
    'N/A for balances',
    'N/A for balances',
    tb.reporting_curr_cd,
    tb.functional_curr_cd,
    ROUND(SUM(tb.reporting_ending_balance), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN tb.reporting_ending_balance
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN tb.reporting_ending_balance
                                   ELSE 0
                                   END), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN tb.reporting_ending_balance
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN tb.reporting_ending_balance
                                   ELSE 0
                                   END), 2),
    ROUND(SUM(tb.functional_ending_balance), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN tb.functional_ending_balance
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN tb.functional_ending_balance
                                   ELSE 0
                                   END), 2),
    ROUND(SUM(
              CASE
              WHEN coa.ey_account_type = 'Revenue'
              THEN tb.functional_ending_balance
              ELSE 0
              END), 2) + ROUND(SUM(
                                   CASE
                                   WHEN coa.ey_account_type = 'Expenses'
                                   THEN tb.functional_ending_balance
                                   ELSE 0
                                   END), 2),
    'Ending balance'
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
    fc.fiscal_period_seq IN
    (
      SELECT MAX(pp1.fiscal_period_seq_end)
      FROM
        Parameters_period pp1
      WHERE
        pp1.fiscal_year_cd = pp.fiscal_year_cd
        AND pp1.year_flag = pp.year_flag)
    AND pp.year_flag IN ('CY',
                         'PY')
    AND tb.ver_end_date_id IS NULL
  GROUP BY
    coa.ey_account_type,
    coa.ey_account_class,
    fc.fiscal_period_cd,
    pp.year_flag_desc,
    pp.period_flag_desc,
    pp.year_flag,
    pp.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    coa.ey_account_group_I,
    tb.reporting_curr_cd,
    tb.functional_curr_cd);