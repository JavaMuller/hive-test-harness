SELECT
		GL.coa_id as [COA Id]
		,GL.period_id as [Period Id]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class	  AS [Account Class]
		,coa.ey_account_sub_class	  AS [Account Sub-class]
		,coa.gl_account_cd AS [GL Account Code]
		,coa.gl_account_name AS [GL Account Name]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I AS [Account Group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group as [Business unit group]

		,S1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]


		,GL.year_flag as [Year flag]
		,GL.period_flag as [Period flag]
		,GL.Accounting_period  AS [Accounting period]

		,GL.Accounting_sub_period AS [Accounting sub period]
		,GL.[YEAR] AS [Year]
		,GL.[Fiscal_period] AS [Fiscal period]

		,src.source_group AS [Source group]
		,src.Source_Ref AS [Source]


		,GL.journal_type AS [Journal type]
		,dp.department AS [Preparer department]
		,dp.preparer_Ref AS [Preparer]

		,dp1.department AS [Approver department]
		,dp1.preparer_ref AS [Approver]
		,GL.Functional_Currency_Code  AS  [Functional Currency Code]
		,GL.Reporting_currency_code  AS  [Reporting currency code]
		,GL.Net_reporting_amount  AS  [Net reporting amount]
		,GL.Net_reporting_amount_credit  AS  [Net reporting amount credit]
		,GL.Net_reporting_amount_debit  AS  [Net reporting amount debit]
		,GL.Net_reporting_amount_current  AS  [Net reporting amount current]
		,GL.Net_reporting_amount_credit_current  AS  [Net reporting amount credit current]
		,GL.Net_reporting_amount_debit_current  AS  [Net reporting amount debit current]
		,GL.Net_reporting_amount_interim  AS  [Net reporting amount interim]
		,GL.Net_reporting_amount_credit_interim  AS  [Net reporting amount credit interim]
		,GL.Net_reporting_amount_debit_interim  AS  [Net reporting amount debit interim]
		,GL.Net_reporting_amount_prior  AS  [Net reporting amount prior]
		,GL.Net_reporting_amount_credit_prior  AS  [Net reporting amount credit prior]
		,GL.Net_reporting_amount_debit_prior  AS  [Net reporting amount debit prior]
		,GL.Net_functional_amount  AS  [Net functional amount]
		,GL.Net_functional_amount_credit  AS  [Net functional amount credit]
		,GL.Net_functional_amount_debit  AS  [Net functional amount debit]
		,GL.Net_functional_amount_current  AS  [Net functional amount current]
		,GL.Net_functional_amount_credit_current  AS  [Net functional amount credit current]
		,GL.Net_functional_amount_debit_current  AS  [Net functional amount debit current]
		,GL.Net_functional_amount_interim  AS  [Net functional amount interim]
		,GL.Net_functional_amount_credit_interim  AS  [Net functional amount credit interim]
		,GL.Net_functional_amount_debit_interim  AS  [Net functional amount debit interim]
		,GL.Net_functional_amount_prior  AS  [Net functional amount prior]
		,GL.Net_functional_amount_credit_prior  AS  [Net functional amount credit prior]
		,GL.Net_functional_amount_debit_prior  AS  [Net functional amount debit prior]
		,GL.Source_type  AS  [Source type]
		,GL.Period_end_date  AS  [Period end date]
		,GL.Fiscal_period_sequence  AS  [Fiscal period sequence]
		,GL.Fiscal_period_sequence_end  AS  [Fiscal period sequence end]


	FROM dbo.[GL_001_Balance_Sheet] GL (NOLOCK)
		LEFT OUTER JOIN dbo.DIM_Chart_of_Accounts coa ON coa.Coa_id = GL.coa_id
			AND coa.Coa_id = GL.coa_id
		LEFT OUTER JOIN dbo.Dim_Preparer dp	on dp.user_listing_id = GL.user_listing_id
		LEFT OUTER JOIN dbo.Dim_Preparer dp1	on dp1.user_listing_id = GL.approved_by_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = GL.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = GL.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = GL.Segment_1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = GL.Segment_2_id