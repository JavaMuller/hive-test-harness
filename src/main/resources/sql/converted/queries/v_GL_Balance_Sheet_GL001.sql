SELECT
    GL.coa_id ,
    GL.period_id ,
    coa.ey_account_type ,
    coa.ey_account_sub_type ,
    coa.ey_account_class ,
    coa.ey_account_sub_class ,
    coa.gl_account_cd ,
    coa.gl_account_name ,
    coa.ey_gl_account_name ,
    coa.ey_account_group_I ,
    bu.bu_ref ,
    bu.bu_group ,
    S1.ey_segment_ref ,
    s2.ey_segment_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    GL.year_flag ,
    GL.period_flag ,
    GL.Accounting_period ,
    GL.Accounting_sub_period ,
    GL.[YEAR         ] ,
    GL.[Fiscal_period] ,
    src.source_group ,
    src.Source_Ref ,
    GL.journal_type ,
    dp.department ,
    dp.preparer_Ref ,
    dp1.department ,
    dp1.preparer_ref ,
    GL.Functional_Currency_Code             AS [Functional Currency Code] ,
    GL.Reporting_currency_code              AS [Reporting currency code] ,
    GL.Net_reporting_amount                 AS [Net reporting amount] ,
    GL.Net_reporting_amount_credit          AS [Net reporting amount credit] ,
    GL.Net_reporting_amount_debit           AS [Net reporting amount debit] ,
    GL.Net_reporting_amount_current         AS [Net reporting amount CURRENT] ,
    GL.Net_reporting_amount_credit_current  AS [Net reporting amount credit CURRENT] ,
    GL.Net_reporting_amount_debit_current   AS [Net reporting amount debit CURRENT] ,
    GL.Net_reporting_amount_interim         AS [Net reporting amount interim] ,
    GL.Net_reporting_amount_credit_interim  AS [Net reporting amount credit interim] ,
    GL.Net_reporting_amount_debit_interim   AS [Net reporting amount debit interim] ,
    GL.Net_reporting_amount_prior           AS [Net reporting amount prior] ,
    GL.Net_reporting_amount_credit_prior    AS [Net reporting amount credit prior] ,
    GL.Net_reporting_amount_debit_prior     AS [Net reporting amount debit prior] ,
    GL.Net_functional_amount                AS [Net functional amount] ,
    GL.Net_functional_amount_credit         AS [Net functional amount credit] ,
    GL.Net_functional_amount_debit          AS [Net functional amount debit] ,
    GL.Net_functional_amount_current        AS [Net functional amount CURRENT] ,
    GL.Net_functional_amount_credit_current AS [Net functional amount credit CURRENT] ,
    GL.Net_functional_amount_debit_current  AS [Net functional amount debit CURRENT] ,
    GL.Net_functional_amount_interim        AS [Net functional amount interim] ,
    GL.Net_functional_amount_credit_interim AS [Net functional amount credit interim] ,
    GL.Net_functional_amount_debit_interim  AS [Net functional amount debit interim] ,
    GL.Net_functional_amount_prior          AS [Net functional amount prior] ,
    GL.Net_functional_amount_credit_prior   AS [Net functional amount credit prior] ,
    GL.Net_functional_amount_debit_prior    AS [Net functional amount debit prior] ,
    GL.Source_type                          AS [Source type] ,
    GL.Period_end_date                      AS [Period
END DATE                                       ] ,
GL.Fiscal_period_sequence                   AS [Fiscal period sequence] ,
GL.Fiscal_period_sequence_end               AS [Fiscal period sequence
END                                            ]
FROM
    dbo.[GL_001_Balance_Sheet] GL (NOLOCK)
LEFT OUTER JOIN
    dbo.DIM_Chart_of_Accounts coa
ON
    coa.Coa_id = GL.coa_id
AND coa.Coa_id = GL.coa_id
LEFT OUTER JOIN
    dbo.Dim_Preparer dp
ON
    dp.user_listing_id = GL.user_listing_id
LEFT OUTER JOIN
    dbo.Dim_Preparer dp1
ON
    dp1.user_listing_id = GL.approved_by_id
LEFT OUTER JOIN
    dbo.v_Business_unit_listing BU
ON
    Bu.bu_id = GL.bu_id
LEFT OUTER JOIN
    dbo.v_Source_listing src
ON
    src.source_id = GL.source_id
LEFT OUTER JOIN
    dbo.v_Segment01_listing S1
ON
    S1.ey_segment_id = GL.Segment_1_id
LEFT OUTER JOIN
    dbo.v_Segment02_listing S2
ON
    S2.ey_segment_id = GL.Segment_2_id