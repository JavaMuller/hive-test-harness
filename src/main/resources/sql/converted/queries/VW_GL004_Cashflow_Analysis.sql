
	Select

		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc END 
		,PP.period_flag_desc 
		,PP.year_flag  
		,PP.period_flag   
		,f.EY_period 
		,f.coa_id					-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,coa.ey_account_type 
		,coa.ey_account_sub_type 
		,coa.ey_account_class 
		,coa.ey_account_sub_class 
		,coa.gl_account_name 
		,coa.gl_account_cd 
		,coa.ey_gl_account_name 
		,coa.ey_account_group_I 
		,ISNULL(F.user_listing_id,0)	AS		[Preparer ID]							-- [Manish]23Jun2014: added on Stu's requirement for GL004

		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.preparer_ref END 
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.department END 
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.department END 
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.preparer_ref END  

		,bu.bu_group 
		,bu.bu_REF 
		,bu.bu_cd 
		,s1.ey_segment_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_group 
		,s2.ey_segment_ref  
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_group END 
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_ref END 

		,f.sys_man_ind 					-- [Manish]24Jun2014: added on Stu's requirement for GL004
		,f.journal_type 
		,f.functional_curr_cd 
		,f.reporting_curr_cd 

		,F.source_type 


		,f.net_reporting_amount 
		,f.net_reporting_amount_credit 
		,f.net_reporting_amount_debit 

		,f.net_functional_amount 
		,f.net_functional_amount_credit 
		,f.net_functional_amount_debit 


		,ISNULL(f.source_id,0) 
		,ISNULL(f.segment1_id,0) 
		,ISNULL(f.segment2_id,0) 
		,ISNULL(f.approved_by_id,0) 

	FROM dbo.GL_004_Cashflow_Analysis F
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id and coa.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = F.approved_by_id
		LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id



	/*

	Select

		--f.year_flag_desc 
		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE f.year_flag_desc END 
		,f.period_flag_desc 
		,f.EY_period 
		,f.coa_id									-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,F.ey_account_type 
		,F.ey_account_sub_type 
		,F.ey_account_class 
		,F.ey_account_sub_class 
		,F.gl_account_name 
		,F.gl_account_cd 
		,F.ey_gl_account_name 
		,F.ey_account_group_I 
		,F.user_listing_id	AS		[Preparer ID]							-- [Manish]23Jun2014: added on Stu's requirement for GL004
		,F.preparer_ref 
		,f.department 
		,f.approver_department 
		,f.approver_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group 
		--,f.bu_REF 
		--,f.segment1_group 
		--,f.segment1_ref 
		--,f.segment2_group 
		--,f.segment2_ref  
		--,f.source_group 
		--,f.source_ref 
		,bu.bu_group 
		,bu.bu_REF 
		,bu.bu_cd 
		,s1.ey_segment_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_group 
		,s2.ey_segment_ref  
		,src.source_group 
		,src.source_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,f.sys_manual_ind 					-- [Manish]24Jun2014: added on Stu's requirement for GL004
		,f.journal_type 
		,f.functional_curr_cd 
		,f.reporting_amount_curr_cd 

		,'Activity' 
		--,tb.functional_beginning_balance AS 'Functional beginning balance'
		--,tb.functional_ending_balance AS 'Functional ending balance'
		--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
		--,tb.reporting_ending_balance AS 'Reporting ending balance'

		,SUM(f.reporting_amount) 
		,SUM(f.reporting_amount_credit) 
		,SUM(f.reporting_amount_debit) 

		,SUM(f.functional_amount) 
		,SUM(f.functional_credit_amount) 
		,SUM(f.functional_debit_amount) 

		--,f.cash_group AS 'Cash Group' -- commented by prabakar since cash group concept is used in GL
		-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
		,f.source_id 
		,f.segment1_id 
		,f.segment2_id 
		,f.approved_by_id 
	FROM dbo.Flat_JE F
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	--WHERE f.Cash_Group IS NOT NULL -- commented by prabakar based on the discussion with Amod - cash group concept is used in GL
	 where F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY

		f.year_flag_desc
		,f.year_flag
		,f.period_flag_desc
		,f.EY_period
		,f.coa_id					-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,F.ey_account_type
		,F.ey_account_sub_type
		,F.ey_account_class
		,F.ey_account_sub_class
		,F.gl_account_name
		,F.gl_account_cd
		,F.ey_gl_account_name
		,F.ey_account_group_I
		,F.user_listing_id			-- [Manish]23Jun2014: added on Stu's requirement for GL004
		,F.preparer_ref
		,f.department
		,f.approver_department
		,f.approver_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group
		--,f.bu_REF
		--,f.segment1_group
		--,f.segment1_ref
		--,f.segment2_group
		--,f.segment2_ref
		--,f.source_group
		--,f.source_ref

		,bu.bu_group
		,bu.bu_REF
		,bu.bu_cd
		,s1.ey_segment_group
		,s1.ey_segment_ref
		,s2.ey_segment_group
		,s2.ey_segment_ref
		,src.source_group
		,src.source_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,f.sys_manual_ind
		,f.journal_type
		,f.functional_curr_cd
		,f.reporting_amount_curr_cd
		-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
		,f.source_id
		,f.segment1_id
		,f.segment2_id
		,f.approved_by_id

	UNION
		SELECT

			CASE WHEN pp.year_flag = 'CY' THEN 'Current'
				WHEN pp.year_flag = 'PY' THEN 'Prior'
				WHEN pp.year_flag = 'SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc END
			
			,pp.period_flag_desc 
			,fc.fiscal_period_cd 
			,coa.coa_id									-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,coa.ey_account_type 
			,coa.ey_account_sub_type 
			,coa.ey_account_class 
			,coa.ey_account_sub_class 
			,coa.gl_account_name 
			,coa.gl_account_cd 
			,coa.ey_gl_account_name 
			,coa.ey_account_group_I 
			,0 													-- [Manish]23Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' 
			,'N/A for balances' 
			,'N/A for balances' 
			,'N/A for balances' 
			,bu.bu_group 
			,bu.bu_REF 
			,bu.bu_cd 
			,s1.ey_segment_group 
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			,s1.ey_segment_ref 
			,s2.ey_segment_group 
			,s2.ey_segment_ref  
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,'N/A for balances' 
			,'N/A for balances' 
			,'N/A for balances'							-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' 
			,tb.functional_curr_cd 
			,tb.reporting_curr_cd 
			,'Beginning balance' 

			,tb.reporting_beginning_balance  
			,0.0 
			,0.0 
			,tb.functional_beginning_balance  
			,0.0 
			,0.0 
			-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
			,0 
			,tb.segment1_id 
			,tb.segment2_id 
			,0 
		FROM dbo.TrialBalance tb

			INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end)
								FROM dbo.Parameters_period pp1
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
							)
		and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd

	UNION

		SELECT

			CASE WHEN pp.year_flag = 'CY' THEN 'Current'
				WHEN pp.year_flag = 'PY' THEN 'Prior'
				WHEN pp.year_flag = 'SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc END
			
			,pp.period_flag_desc 
			,fc.fiscal_period_cd 
			,coa.coa_id									-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,coa.ey_account_type 
			,coa.ey_account_sub_type 
			,coa.ey_account_class 
			,coa.ey_account_sub_class 
			,coa.gl_account_name 
			,coa.gl_account_cd 
			,coa.ey_gl_account_name 
			,coa.ey_account_group_I 
			,0 AS 	[Preparer ID]												-- [Manish]23Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' 
			,'N/A for balances' 
			,'N/A for balances' 
			,'N/A for balances' 
			,bu.bu_group 
			,bu.bu_REF 
			,bu.bu_cd 
			,s1.ey_segment_group 
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			,s1.ey_segment_ref 
			,s2.ey_segment_group 
			,s2.ey_segment_ref  
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,'N/A for balances' 
			,'N/A for balances' 
			,'N/A for balances'						-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' 
			,tb.functional_curr_cd 
			,tb.reporting_curr_cd 
			,'Ending balance' 

			,TB.reporting_ending_balance  
			,0.0 
			,0.0 
			,tb.functional_ending_balance 
			,0.0 
			,0.0 
			-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
			,0 
			,tb.segment1_id 
			,tb.segment2_id 
			,0 
		FROM dbo.TrialBalance tb

			INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end)
								FROM dbo.Parameters_period pp1
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								)
		and  tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd */