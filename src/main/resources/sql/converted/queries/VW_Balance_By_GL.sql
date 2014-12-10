
	SELECT
		gl.coa_id 
		,gl.ey_account_type 
		,gl.ey_account_sub_type 
		,gl.ey_account_class 
		,gl.ey_account_sub_class 
		,gl.gl_account_cd 
		,gl.gl_account_name 
		,gl.ey_gl_account_name 
		,gl.ey_account_group_I
		,gl.department 
		,gl.preparer_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,source_group AS  [Source group]
		--,source_ref 
		--,segment1_ref 
		--,segment2_ref 
		--,segment1_group AS  [Segment 1 group]
		--,segment2_group AS  [Segment 2 group]
		--,bu_group AS  [Business unit group]
		--,bu_ref AS  [Business unit]

		,isnull(src.source_group,'N/A for balances')   -- Is null condition was added outside the view to since TB wouldn't have source info
		,isnull(src.Source_ref,'N/A for balances')  -- Is null condition was added outside the view to since TB wouldn't have source info
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,bu.bu_group 
		,bu.bu_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		,gl.year_flag_desc AS  [Accounting period]
		,gl.period_flag_desc AS  [Accounting sub period]
		,gl.year_flag 
		,gl.period_flag 
		,gl.ey_period AS  [Fiscal period]
		,gl.functional_curr_cd 
		,gl.reporting_curr_cd AS  [Reporting currency code]
		--,' 
		--,'' 
		--,gl.sys_manual_ind 
		,gl.journal_type 
		,gl.trial_balance_start_date_id
		,gl.trial_balance_end_date_id

		,gl.Beginning_balance 
		,gl.Ending_balance 

		--,Calc_Ending_Bal 
		--,Diff_between_Calc_Ending_And_Ending 

		,gl.Net_reporting_amount AS  [Net reporting amount]
		,gl.Net_functional_amount AS  [Net functional amount]

		,gl.functional_beginning_balance 
		,gl.functional_ending_balance 
		,gl.reporting_beginning_balance 
		,gl.reporting_ending_balance 

		,gl.Calc_reporting_ending_bal 
		,gl.Diff_btw_calc_end_and_report_ending 
		,gl.Calc_functional_ending_bal AS  [Calculated functional ending balance]
		,gl.Diff_btw_calc_end_and_func_ending 

		--,TOTAL_CREDIT AS  [Net reporting credit amount]
		--,TOTAL_DEBIT AS  [Net reporting debit amount]

		--,functional_credit_amount AS  [Net functional credit amount]
		--,functional_debit_amount AS  [Net functional debit amount]



	FROM         dbo.GL_016_Balance_By_GL gl
	 /*  added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = gl.bu_id
			LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = gl.source_id
			LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = gl.segment1_id
			LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = gl.segment2_id
		/*  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */