
	Select

		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,PP.year_flag  AS [Year flag]
		,PP.period_flag   AS [Period flag]
		,f.EY_period AS [Fiscal period]
		,f.coa_id	AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_name AS [GL Account Name]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I AS [Account Group]
		,ISNULL(F.user_listing_id,0)	AS		[Preparer ID]							-- [Manish]23Jun2014: added on Stu's requirement for GL004

		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.preparer_ref END AS [Preparer]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.department END AS [Preparer department]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.department END AS [Approver department]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.preparer_ref END  AS [Approver]

		,bu.bu_group AS [Business unit group]
		,bu.bu_REF AS [Business unit]
		,bu.bu_cd AS [Business unit code]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group AS [Segment 2 group]
		,s2.ey_segment_ref  AS [Segment 2]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_group END AS [Source group]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_ref END AS [Source]

		,f.sys_man_ind AS [EY system manual indicator]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
		,f.journal_type AS [Journal type]
		,f.functional_curr_cd AS [Functional Currency Code]
		,f.reporting_curr_cd AS [Reporting currency code]

		,F.source_type AS [Source Type]


		,f.net_reporting_amount AS [Net reporting amount]
		,f.net_reporting_amount_credit AS [Net reporting amount credit]
		,f.net_reporting_amount_debit AS [Net reporting amount debit]

		,f.net_functional_amount AS [Net functional amount]
		,f.net_functional_amount_credit AS [Net functional amount credit]
		,f.net_functional_amount_debit AS [Net functional amount debit]


		,ISNULL(f.source_id,0) AS [Source id]
		,ISNULL(f.segment1_id,0) AS [segment1 id]
		,ISNULL(f.segment2_id,0) AS [segment2 id]
		,ISNULL(f.approved_by_id,0) AS [Approver ID]

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

		--f.year_flag_desc AS [Accounting period]
		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE f.year_flag_desc END AS [Accounting period]
		,f.period_flag_desc AS [Accounting sub period]
		,f.EY_period AS [Fiscal period]
		,f.coa_id					AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,F.ey_account_type AS [Account Type]
		,F.ey_account_sub_type AS [Account Sub-type]
		,F.ey_account_class AS [Account Class]
		,F.ey_account_sub_class AS [Account Sub-class]
		,F.gl_account_name AS [GL Account Name]
		,F.gl_account_cd AS [GL Account Cd]
		,F.ey_gl_account_name AS [GL Account]
		,F.ey_account_group_I AS [Account Group]
		,F.user_listing_id	AS		[Preparer ID]							-- [Manish]23Jun2014: added on Stu's requirement for GL004
		,F.preparer_ref AS [Preparer]
		,f.department AS [Preparer department]
		,f.approver_department AS [Approver department]
		,f.approver_ref AS [Approver]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group AS [Business unit group]
		--,f.bu_REF AS [Business unit]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_group AS [Segment 2 group]
		--,f.segment2_ref  AS [Segment 2]
		--,f.source_group AS [Source group]
		--,f.source_ref AS [Source]
		,bu.bu_group AS [Business unit group]
		,bu.bu_REF AS [Business unit]
		,bu.bu_cd AS [Business unit code]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group AS [Segment 2 group]
		,s2.ey_segment_ref  AS [Segment 2]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,f.sys_manual_ind AS [EY system manual indicator]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
		,f.journal_type AS [Journal type]
		,f.functional_curr_cd AS [Functional Currency Code]
		,f.reporting_amount_curr_cd AS [Reporting currency code]

		,'Activity' AS [Source Type]
		--,tb.functional_beginning_balance AS 'Functional beginning balance'
		--,tb.functional_ending_balance AS 'Functional ending balance'
		--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
		--,tb.reporting_ending_balance AS 'Reporting ending balance'

		,SUM(f.reporting_amount) AS [Net reporting amount]
		,SUM(f.reporting_amount_credit) AS [Net reporting amount credit]
		,SUM(f.reporting_amount_debit) AS [Net reporting amount debit]

		,SUM(f.functional_amount) AS [Net functional amount]
		,SUM(f.functional_credit_amount) AS [Net functional amount credit]
		,SUM(f.functional_debit_amount) AS [Net functional amount debit]

		--,f.cash_group AS 'Cash Group' -- commented by prabakar since cash group concept is used in GL
		-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
		,f.source_id AS [Source id]
		,f.segment1_id AS [segment1 id]
		,f.segment2_id AS [segment2 id]
		,f.approved_by_id AS [Approver ID]
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
			AS [Accounting period]
			,pp.period_flag_desc AS [Accounting sub period]
			,fc.fiscal_period_cd AS [Fiscal period]
			,coa.coa_id					AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,coa.ey_account_type AS [Account Type]
			,coa.ey_account_sub_type AS [Account Sub-type]
			,coa.ey_account_class AS [Account Class]
			,coa.ey_account_sub_class AS [Account Sub-class]
			,coa.gl_account_name AS [GL Account Name]
			,coa.gl_account_cd AS [GL Account Cd]
			,coa.ey_gl_account_name AS [GL Account]
			,coa.ey_account_group_I AS [Account Group]
			,0 AS [Preparer ID]													-- [Manish]23Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Preparer]
			,'N/A for balances' AS [Preparer department]
			,'N/A for balances' AS [Approver department]
			,'N/A for balances' AS [Approver]
			,bu.bu_group AS [Business unit group]
			,bu.bu_REF AS [Business unit]
			,bu.bu_cd AS [Business unit code]
			,s1.ey_segment_group AS [Segment 1 group]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			,s1.ey_segment_ref AS [Segment 1]
			,s2.ey_segment_group AS [Segment 2 group]
			,s2.ey_segment_ref  AS [Segment 2]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,'N/A for balances' AS [Source group]
			,'N/A for balances' AS [Source]
			,'N/A for balances'		AS [EY system manual indicator]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Journal type]
			,tb.functional_curr_cd AS [Functional Currency Code]
			,tb.reporting_curr_cd AS [Reporting currency code]
			,'Beginning balance' AS [Source Type]

			,tb.reporting_beginning_balance  AS [Net reporting amount]
			,0.0 AS [Net reporting amount credit]
			,0.0 AS [Net reporting amount debit]
			,tb.functional_beginning_balance  AS [Net functional amount]
			,0.0 AS [Net functional amount credit]
			,0.0 AS [Net functional amount debit]
			-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
			,0 AS [Source id]
			,tb.segment1_id AS [segment1 id]
			,tb.segment2_id AS [segment2 id]
			,0 AS [Approver ID]
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
			AS [Accounting period]
			,pp.period_flag_desc AS [Accounting sub period]
			,fc.fiscal_period_cd AS [Fiscal period]
			,coa.coa_id					AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,coa.ey_account_type AS [Account Type]
			,coa.ey_account_sub_type AS [Account Sub-type]
			,coa.ey_account_class AS [Account Class]
			,coa.ey_account_sub_class AS [Account Sub-class]
			,coa.gl_account_name AS [GL Account Name]
			,coa.gl_account_cd AS [GL Account Cd]
			,coa.ey_gl_account_name AS [GL Account]
			,coa.ey_account_group_I AS [Account Group]
			,0 AS 	[Preparer ID]												-- [Manish]23Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Preparer]
			,'N/A for balances' AS [Preparer department]
			,'N/A for balances' AS [Approver department]
			,'N/A for balances' AS [Approver]
			,bu.bu_group AS [Business unit group]
			,bu.bu_REF AS [Business unit]
			,bu.bu_cd AS [Business unit code]
			,s1.ey_segment_group AS [Segment 1 group]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			,s1.ey_segment_ref AS [Segment 1]
			,s2.ey_segment_group AS [Segment 2 group]
			,s2.ey_segment_ref  AS [Segment 2]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,'N/A for balances' AS [Source group]
			,'N/A for balances' AS [Source]
			,'N/A for balances'		AS [EY system manual indicator]				-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Journal type]
			,tb.functional_curr_cd AS [Functional Currency Code]
			,tb.reporting_curr_cd AS [Reporting currency code]
			,'Ending balance' AS [Source Type]

			,TB.reporting_ending_balance  AS [Net reporting amount]
			,0.0 AS [Net reporting amount credit]
			,0.0 AS [Net reporting amount debit]
			,tb.functional_ending_balance AS [Net functional amount]
			,0.0 AS [Net functional amount credit]
			,0.0 AS [Net functional amount debit]
			-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
			,0 AS [Source id]
			,tb.segment1_id AS [segment1 id]
			,tb.segment2_id AS [segment2 id]
			,0 AS [Approver ID]
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