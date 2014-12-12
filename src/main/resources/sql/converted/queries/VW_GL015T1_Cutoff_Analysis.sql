/*
  FAILED: ParseException line 38:28 cannot recognize input near 'VARCHAR' '(' '10' in function specification
 */

SELECT
  CASE
  WHEN FJ.year_flag = 'CY'
  THEN 'Current'
  WHEN FJ.year_flag = 'PY'
  THEN 'Prior'
  WHEN FJ.year_flag = 'SP'
  THEN 'Subsequent'
  ELSE PP.year_flag_desc
  END,
  PP.period_flag_desc,
  FJ.EY_period,
  coa.ey_account_type,
  coa.ey_account_sub_type,
  coa.ey_account_class,
  coa.ey_account_sub_class,
  coa.gl_account_name,
  coa.gl_account_cd,
  coa.gl_account_cd,
  coa.ey_gl_account_name,
  coa.ey_account_group_I,
  Ul.preparer_ref,
  ul.department,
  aul.department,
  aul.preparer_ref,
  bu.bu_group,
  bu.bu_ref,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  src.source_group,
  src.source_ref,
  FJ.journal_type,
  FJ.functional_curr_cd,
  FJ.reporting_amount_curr_cd,
  'Activity',
  CONVERT(DATETIME, CONVERT(VARCHAR(10), Fj.entry_date_id, 101), 101),
  CONVERT(DATETIME, CONVERT(VARCHAR(10), Fj.effective_date_id, 101), 101),
  SUM(FJ.net_reporting_amount),
  SUM(FJ.net_reporting_amount_credit),
  SUM(FJ.net_reporting_amount_debit),
  SUM(FJ.net_functional_amount),
  SUM(FJ.net_functional_amount_credit),
  SUM(FJ.net_functional_amount_debit)
FROM
  FT_GL_Account FJ
  INNER JOIN
  v_Chart_of_accounts coa
    ON
      coa.coa_id = FJ.coa_id
      AND COA.bu_id = FJ.bu_id
  LEFT OUTER JOIN
  v_User_listing UL
    ON
      UL.user_listing_id = FJ.user_listing_id
  LEFT OUTER JOIN
  v_User_listing AUL
    ON
      AUL.user_listing_id = FJ.approved_by_id
  LEFT OUTER JOIN
  Parameters_period pp
    ON
      PP.period_flag = FJ.period_flag
      AND PP.year_flag = FJ.year_flag
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
GROUP BY
  COA.ey_account_type,
  COA.ey_account_sub_type,
  COA.ey_account_class,
  COA.ey_account_sub_class,
  COA.gl_account_name,
  COA.gl_account_cd,
  COA.ey_gl_account_name,
  COA.ey_account_group_I,
  UL.preparer_ref,
  UL.department,
  pp.period_flag_desc,
  FJ.EY_period,
  AUL.preparer_ref,
  AUL.department,
  bu.bu_group,
  bu.bu_ref,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  src.source_group,
  src.source_ref,
  journal_type,
  entry_date_id,
  effective_date_id,
  reporting_amount_curr_cd,
  functional_curr_cd,
  FJ.year_flag,
  pp.year_flag_desc
UNION
SELECT
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
  fc.fiscal_period_cd,
  coa.ey_account_type,
  coa.ey_account_sub_type,
  coa.ey_account_class,
  coa.ey_account_sub_class,
  coa.gl_account_name,
  coa.gl_account_cd,
  coa.gl_account_cd,
  coa.ey_gl_account_name,
  coa.ey_account_group_I,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  bu.bu_group,
  bu.bu_REF,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  tb.functional_curr_cd,
  tb.reporting_curr_cd,
  'Beginning balance',
  NULL,
  NULL,
  tb.reporting_beginning_balance,
  0.0,
  0.0,
  tb.functional_beginning_balance,
  0.0,
  0.0
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
  fc.fiscal_period_seq =
  (
    SELECT MAX(pp1.fiscal_period_seq_end)
    FROM
      Parameters_period pp1
    WHERE
      PP1.year_flag = PP.year_flag
      AND pp1.fiscal_year_cd = pp.fiscal_year_cd)
  AND tb.ver_end_date_id IS NULL
UNION
SELECT
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
  fc.fiscal_period_cd,
  coa.ey_account_type,
  coa.ey_account_sub_type,
  coa.ey_account_class,
  coa.ey_account_sub_class,
  coa.gl_account_name,
  coa.gl_account_cd,
  coa.gl_account_cd,
  coa.ey_gl_account_name,
  coa.ey_account_group_I,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  bu.bu_group,
  bu.bu_REF,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  tb.functional_curr_cd,
  tb.reporting_curr_cd,
  'Ending balance',
  NULL,
  NULL,
  TB.reporting_ending_balance,
  0.0,
  0.0,
  tb.functional_ending_balance,
  0.0,
  0.0
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
  fc.fiscal_period_seq =
  (
    SELECT MAX(pp1.fiscal_period_seq_end)
    FROM
      Parameters_period pp1
    WHERE
      PP1.year_flag = PP.year_flag
      AND pp1.fiscal_year_cd = pp.fiscal_year_cd)
  AND tb.ver_end_date_id IS NULL;