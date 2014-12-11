SELECT
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
  PP.year_flag,
  PP.period_flag,
  f.EY_period,
  f.coa_id,
  coa.ey_account_type,
  coa.ey_account_sub_type,
  coa.ey_account_class,
  coa.ey_account_sub_class,
  coa.gl_account_name,
  coa.gl_account_cd,
  coa.ey_gl_account_name,
  coa.ey_account_group_I,
  COALESCE(F.user_listing_id, 0),
  CASE
  WHEN f.source_type <> 'Activity'
  THEN 'N/A for balances'
  ELSE UL.preparer_ref
  END,
  CASE
  WHEN f.source_type <> 'Activity'
  THEN 'N/A for balances'
  ELSE UL.department
  END,
  CASE
  WHEN f.source_type <> 'Activity'
  THEN 'N/A for balances'
  ELSE AUL.department
  END,
  CASE
  WHEN f.source_type <> 'Activity'
  THEN 'N/A for balances'
  ELSE AUL.preparer_ref
  END,
  bu.bu_group,
  bu.bu_REF,
  bu.bu_cd,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  CASE
  WHEN f.source_type <> 'Activity'
  THEN 'N/A for balances'
  ELSE src.source_group
  END,
  CASE
  WHEN f.source_type <> 'Activity'
  THEN 'N/A for balances'
  ELSE src.source_ref
  END,
  f.sys_man_ind,
  f.journal_type,
  f.functional_curr_cd,
  f.reporting_curr_cd,
  F.source_type,
  f.net_reporting_amount,
  f.net_reporting_amount_credit,
  f.net_reporting_amount_debit,
  f.net_functional_amount,
  f.net_functional_amount_credit,
  f.net_functional_amount_debit,
  COALESCE(f.source_id, 0),
  COALESCE(f.segment1_id, 0),
  COALESCE(f.segment2_id, 0),
  COALESCE(f.approved_by_id, 0)
FROM
  GL_004_Cashflow_Analysis F
  INNER JOIN
  v_Chart_of_accounts coa
    ON
      coa.coa_id = f.coa_id
      AND coa.bu_id = f.bu_id
  LEFT OUTER JOIN
  v_User_listing UL
    ON
      UL.user_listing_id = F.user_listing_id
  LEFT OUTER JOIN
  v_User_listing AUL
    ON
      AUL.user_listing_id = F.approved_by_id
  LEFT OUTER JOIN
  Parameters_period PP
    ON
      PP.year_flag = F.year_flag
      AND PP.period_flag = F.period_flag
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
  ,
  bu.bu_group,
  bu.bu_REF,
  bu.bu_cd,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  src.source_group,
  src.source_ref,
  f.sys_manual_ind,
  f.journal_type,
  f.functional_curr_cd,
  f.reporting_amount_curr_cd,
'Activity' ,
SUM(f.reporting_amount) ,
SUM(f.reporting_amount_credit) ,
SUM(f.reporting_amount_debit) ,
SUM(f.functional_amount) ,
SUM(f.functional_credit_amount) ,
SUM(f.functional_debit_amount) ,
f.source_id,
f.segment1_id,
f.segment2_id,
f.approved_by_id
FROM
Flat_JE F
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
F.ver_end_date_id IS NULL
GROUP BY
f.year_flag_desc,
f.year_flag,
f.period_flag_desc ,
f.EY_period,
f.coa_id,
F.ey_account_type,
F.ey_account_sub_type,
F.ey_account_class ,
F.ey_account_sub_class,
F.gl_account_name,
F.gl_account_cd,
F.ey_gl_account_name,
F.ey_account_group_I ,
F.user_listing_id,
F.preparer_ref,
f.department,
f.approver_department,
f.approver_ref ,
bu.bu_group,
bu.bu_REF,
bu.bu_cd,
s1.ey_segment_group,
s1.ey_segment_ref ,
s2.ey_segment_group,
s2.ey_segment_ref,
src.source_group,
src.source_ref,
f.sys_manual_ind ,
f.journal_type,
f.functional_curr_cd,
f.reporting_amount_curr_cd,
f.source_id,
f.segment1_id,
f.segment2_id,
f.approved_by_id
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
  coa.coa_id,
  coa.ey_account_type,
  coa.ey_account_sub_type,
  coa.ey_account_class,
  coa.ey_account_sub_class,
  coa.gl_account_name,
  coa.gl_account_cd,
  coa.ey_gl_account_name,
  coa.ey_account_group_I,
  0,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  bu.bu_group,
  bu.bu_REF,
  bu.bu_cd,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  tb.functional_curr_cd,
  tb.reporting_curr_cd,
  'Beginning balance',
  tb.reporting_beginning_balance,
  0.0,
  0.0,
  tb.functional_beginning_balance,
  0.0,
  0.0,
  0,
  tb.segment1_id,
  tb.segment2_id,
  0
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
      pp1.fiscal_year_cd = pp.fiscal_year_cd)
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
  coa.coa_id,
  coa.ey_account_type,
  coa.ey_account_sub_type,
  coa.ey_account_class,
  coa.ey_account_sub_class,
  coa.gl_account_name,
  coa.gl_account_cd,
  coa.ey_gl_account_name,
  coa.ey_account_group_I,
  0,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  bu.bu_group,
  bu.bu_REF,
  bu.bu_cd,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  'N/A for balances',
  tb.functional_curr_cd,
  tb.reporting_curr_cd,
  'Ending balance',
  TB.reporting_ending_balance,
  0.0,
  0.0,
  tb.functional_ending_balance,
  0.0,
  0.0,
  0,
  tb.segment1_id,
  tb.segment2_id,
  0
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
      pp1.fiscal_year_cd = pp.fiscal_year_cd)
  AND tb.ver_end_date_id IS NULL