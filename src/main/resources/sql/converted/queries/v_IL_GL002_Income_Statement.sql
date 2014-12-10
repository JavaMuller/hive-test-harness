	SELECT
		GL.COA_Id 
		,GL.Period_Id 
		,coa.ey_account_type 
		,coa.ey_account_sub_type 
		,coa.ey_account_class	  
		,coa.ey_account_sub_class	  
		,coa.gl_account_cd 
		,coa.gl_account_name 
		,coa.ey_gl_account_name 
		,coa.ey_account_group_I 
		,BU.bu_ref 
		,BU.bu_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,GL.Year_flag 
		,GL.Period_flag 
		,GL.Accounting_period 
		,GL.Accounting_sub_period 
		,GL.[Year] 
		,GL.Fiscal_period 
		,SRC.Source_group 
		,SRC.[source_ref] 
		,GL.Journal_type 
		,DP.department 
		,DP.preparer_ref 
		,DP1.department 
		,DP1.preparer_ref 
		,GL.Functional_Currency_Code 
		,GL.Reporting_currency_code 
		,GL.Net_reporting_amount 
		,GL.Net_reporting_amount_credit 
		,GL.Net_reporting_amount_debit 
		,GL.Net_reporting_amount_current 
		,GL.Net_reporting_amount_credit_current 
		,GL.Net_reporting_amount_debit_current 
		,GL.Net_reporting_amount_interim 
		,GL.Net_reporting_amount_credit_interim 
		,GL.Net_reporting_amount_debit_interim 
		,GL.Net_reporting_amount_prior 
		,GL.Net_reporting_amount_credit_prior 
		,GL.Net_reporting_amount_debit_prior 
		,GL.Net_functional_amount 
		,GL.Net_functional_amount_credit 
		,GL.Net_functional_amount_debit 
		,GL.Net_functional_amount_current 
		,GL.Net_functional_amount_credit_current 
		,GL.Net_functional_amount_debit_current 
		,GL.Net_functional_amount_interim 
		,GL.Net_functional_amount_credit_interim 
		,GL.Net_functional_amount_debit_interim 
		,GL.Net_functional_amount_prior 
		,GL.Net_functional_amount_credit_prior 
		,GL.Net_functional_amount_debit_prior 
		,GL.Source_type 
		,GL.Period_end_date 

	FROM dbo.[GL_002_Income_Statement] GL
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = GL.COA_Id
		LEFT OUTER JOIN dbo.v_User_listing dp on dp.user_listing_id = gl.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing dp1 on dp1.user_listing_id = gl.approved_by_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = GL.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing Src on src.source_id = GL.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = GL.segment_1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = GL.segment_2_id

		--INNER JOIN dbo.DIM_Chart_of_Accounts coa ON coa.Coa_id = GL.coa_id
		--	AND coa.Coa_id = GL.coa_id
		--LEFT OUTER JOIN dbo.Dim_Preparer dp	on dp.user_listing_id = GL.user_listing_id
		--LEFT OUTER JOIN dbo.Dim_Preparer dp1	on dp1.user_listing_id = GL.approved_by_id