SELECT
  gl.coa_id,
  gl.ey_account_type,
  gl.ey_account_sub_type,
  gl.ey_account_class,
  gl.ey_account_sub_class,
  gl.gl_account_cd,
  gl.gl_account_name,
  gl.ey_gl_account_name,
  gl.ey_account_group_I,
  gl.department,
  gl.preparer_ref,
  ISNULL(src.source_group, 'N/A for balances'),
  ISNULL(src.Source_ref, 'N/A for balances'),
  s1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  bu.bu_group,
  bu.bu_ref,
  gl.year_flag_desc,
  gl.period_flag_desc,
  gl.year_flag,
  gl.period_flag,
  gl.ey_period,
  gl.functional_curr_cd,
  gl.reporting_curr_cd,
  gl.journal_type,
  gl.trial_balance_start_date_id,
  gl.trial_balance_end_date_id,
  gl.Beginning_balance,
  gl.Ending_balance,
  gl.Net_reporting_amount,
  gl.Net_functional_amount,
  gl.functional_beginning_balance,
  gl.functional_ending_balance,
  gl.reporting_beginning_balance,
  gl.reporting_ending_balance,
  gl.Calc_reporting_ending_bal,
  gl.Diff_btw_calc_end_and_report_ending,
  gl.Calc_functional_ending_bal,
  gl.Diff_btw_calc_end_and_func_ending
FROM
  dbo.GL_016_Balance_By_GL gl
  LEFT OUTER JOIN
  dbo.v_Business_unit_listing BU
    ON
      Bu.bu_id = gl.bu_id
  LEFT OUTER JOIN
  dbo.v_Source_listing src
    ON
      src.source_id = gl.source_id
  LEFT OUTER JOIN
  dbo.v_Segment01_listing S1
    ON
      S1.ey_segment_id = gl.segment1_id
  LEFT OUTER JOIN
  dbo.v_Segment02_listing S2
    ON
      S2.ey_segment_id = gl.segment2_id