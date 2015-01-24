SELECT
  GL.coa_id,
  GL.period_id,
  coa.ey_account_type,
  coa.ey_account_sub_type,
  coa.ey_account_class,
  coa.ey_account_sub_class,
  coa.gl_account_cd,
  coa.gl_account_name,
  coa.ey_gl_account_name,
  coa.ey_account_group_I,
  bu.bu_ref,
  bu.bu_group,
  S1.ey_segment_ref,
  s2.ey_segment_ref,
  s1.ey_segment_group,
  s2.ey_segment_group,
  GL.year_flag,
  GL.period_flag,
  GL.Accounting_period,
  GL.Accounting_sub_period,
  GL.YEAR,
  GL.Fiscal_period,
  src.source_group,
  src.Source_Ref,
  GL.journal_type,
  dp.department,
  dp.preparer_Ref,
  dp1.department,
  dp1.preparer_ref,
  GL.Functional_Currency_Code,
  GL.Reporting_currency_code,
  GL.Net_reporting_amount,
  GL.Net_reporting_amount_credit,
  GL.Net_reporting_amount_debit,
  GL.Net_reporting_amount_current,
  GL.Net_reporting_amount_credit_current,
  GL.Net_reporting_amount_debit_current,
  GL.Net_reporting_amount_interim,
  GL.Net_reporting_amount_credit_interim,
  GL.Net_reporting_amount_debit_interim,
  GL.Net_reporting_amount_prior,
  GL.Net_reporting_amount_credit_prior,
  GL.Net_reporting_amount_debit_prior,
  GL.Net_functional_amount,
  GL.Net_functional_amount_credit,
  GL.Net_functional_amount_debit,
  GL.Net_functional_amount_current,
  GL.Net_functional_amount_credit_current,
  GL.Net_functional_amount_debit_current,
  GL.Net_functional_amount_interim,
  GL.Net_functional_amount_credit_interim,
  GL.Net_functional_amount_debit_interim,
  GL.Net_functional_amount_prior,
  GL.Net_functional_amount_credit_prior,
  GL.Net_functional_amount_debit_prior,
  GL.Source_type,
  GL.Period_end_date,
  GL.Fiscal_period_sequence,
  GL.Fiscal_period_sequence_end
FROM
  GL_001_Balance_Sheet GL (NOLOCK)
  LEFT OUTER JOIN
  DIM_Chart_of_Accounts coa
    ON
      coa.Coa_id = GL.coa_id
      AND coa.Coa_id = GL.coa_id
  LEFT OUTER JOIN
  Dim_Preparer dp
    ON
      dp.user_listing_id = GL.user_listing_id
  LEFT OUTER JOIN
  Dim_Preparer dp1
    ON
      dp1.user_listing_id = GL.approved_by_id
  LEFT OUTER JOIN
  v_Business_unit_listing BU
    ON
      Bu.bu_id = GL.bu_id
  LEFT OUTER JOIN
  v_Source_listing src
    ON
      src.source_id = GL.source_id
  LEFT OUTER JOIN
  v_Segment01_listing S1
    ON
      S1.ey_segment_id = GL.Segment_1_id
  LEFT OUTER JOIN
  v_Segment02_listing S2
    ON
      S2.ey_segment_id = GL.Segment_2_id