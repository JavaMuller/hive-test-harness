SELECT
  coa.ey_account_type,
  fj.ey_period,
  CASE
  WHEN fj.year_flag = 'CY'
  THEN 'Current'
  WHEN fj.year_flag = 'PY'
  THEN 'Prior'
  WHEN fj.year_flag = 'SP'
  THEN 'Subsequent'
  ELSE PP.year_flag_desc
  END,
  PP.period_flag_desc,
  fj.year_flag,
  fj.period_flag,
  bu.bu_group,
  bu.bu_ref,
  s1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  fj.reporting_amount_curr_cd,
  fj.functional_curr_cd,
  ROUND(SUM(fj.net_reporting_amount), 2),
  ROUND(SUM(fj.net_functional_amount), 2),
  'Activity',
  pp.end_date,
  NULL,
  NULL,
  NULL
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
UNION
SELECT
  coa.ey_account_sub_type,
  fj.ey_period,
  CASE
  WHEN fj.year_flag = 'CY'
  THEN 'Current'
  WHEN fj.year_flag = 'PY'
  THEN 'Prior'
  WHEN fj.year_flag = 'SP'
  THEN 'Subsequent'
  ELSE pp.year_flag_desc
  END,
  PP.period_flag_desc,
  fj.year_flag,
  fj.period_flag,
  bu.bu_group,
  bu.bu_ref,
  s1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  fj.reporting_amount_curr_cd,
  fj.functional_curr_cd,
  ROUND(SUM(fj.net_reporting_amount), 2),
  ROUND(SUM(fj.net_functional_amount), 2),
  'Activity',
  pp.end_date,
  NULL,
  NULL,
  NULL
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
UNION
SELECT
  coa.ey_account_group_I,
  fj.ey_period,
  CASE
  WHEN fj.year_flag = 'CY'
  THEN 'Current'
  WHEN fj.year_flag = 'PY'
  THEN 'Prior'
  WHEN fj.year_flag = 'SP'
  THEN 'Subsequent'
  ELSE PP.year_flag_desc
  END,
  PP.period_flag_desc,
  fj.year_flag,
  fj.period_flag,
  bu.bu_group,
  bu.bu_ref,
  s1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  fj.reporting_amount_curr_cd,
  fj.functional_curr_cd,
  ROUND(SUM(fj.net_reporting_amount), 2),
  ROUND(SUM(fj.net_functional_amount), 2),
  'Activity',
  pp.end_date,
  NULL,
  NULL,
  NULL
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
UNION
SELECT
  coa.ey_account_type,
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
  s1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  tb.reporting_curr_cd,
  tb.functional_curr_cd,
  ROUND(SUM(tb.reporting_ending_balance), 2),
  ROUND(SUM(tb.functional_ending_balance), 2),
  'Balance',
  pp.END_date,
  fc.fiscal_period_seq,
  pp.fiscal_period_seq_END,
  fc.adjustment_period
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
UNION
SELECT
  coa.ey_account_sub_type,
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
  s1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  tb.reporting_curr_cd,
  tb.functional_curr_cd,
  ROUND(SUM(tb.reporting_ending_balance), 2),
  ROUND(SUM(tb.functional_ending_balance), 2),
  'Balance',
  pp.END_date,
  fc.fiscal_period_seq,
  pp.fiscal_period_seq_END,
  fc.adjustment_period
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
UNION
SELECT
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
  s1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  tb.reporting_curr_cd,
  tb.functional_curr_cd,
  ROUND(SUM(tb.reporting_ending_balance), 2),
  ROUND(SUM(tb.functional_ending_balance), 2),
  'Balance',
  pp.END_date,
  fc.fiscal_period_seq,
  pp.fiscal_period_seq_END,
  fc.adjustment_period
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
  fc.adjustment_period