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
  PP.period_flag_desc,
  pp.year_flag,
  PP.period_flag,
  f.Ey_period,
  f.bu_id,
  f.source_id,
  f.segment1_id,
  f.segment2_id,
  F.sys_man_ind,
  f.journal_type,
  Dp.preparer_ref,
  Dp.department,
  F.reporting_amount_curr_cd,
  F.functional_curr_cd,
  'Common'
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
WHERE
  F.user_listing_id IN
  (
    SELECT fl.user_listing_id
    FROM
      FT_GL_Account fl
    WHERE
      fl.year_flag = 'PY')
  AND F.year_flag = 'CY';