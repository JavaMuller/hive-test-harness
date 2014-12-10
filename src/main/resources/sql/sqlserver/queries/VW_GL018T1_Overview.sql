	SELECT

		coa.ey_account_type AS [Account Type]
		,coa.ey_account_class AS [Account Class]

		--,f.ey_account_sub_type AS [Account Sub-type]
		--,f.ey_account_sub_class AS [Account Sub-class]
		--,f.gl_account_cd AS [GL Account]
		--,f.gl_account_name AS [GL Account Name]

		,coa.ey_account_group_I AS [Account group]
		,f.ey_period AS [Fiscal period]
		--,f.year_flag_desc AS [Accounting period]
		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc
		END AS [Accounting period]

		,PP.period_flag_desc AS [Accounting sub period]
		,f.year_flag as [Year flag]
		,f.period_flag as [Period flag]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group AS [Business unit group]
		--,f.bu_ref as [Business Unit]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,ul.preparer_ref AS [Preparer]
		,ul.department AS [Preparer department]
		,aul.department AS [Approver department]
		,aul.preparer_ref AS [Approver]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_ref AS [Segment 2]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment2_group AS [Segment 2 group]
		--,f.source_group AS [Source group]
		--,f.source_ref as [Source]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,src.source_group AS [Source group]
		,src.source_ref as [Source]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,f.sys_manual_ind as [Journal type]
		,f.journal_type as [Journal type]
		,f.reporting_amount_curr_cd AS [Reporting currency code]
		,f.functional_curr_cd AS [Functional currency code]

		,ROUND(SUM (f.net_reporting_amount),2) AS [Net reporting amount]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_reporting_amount ELSE 0 END),2)
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_reporting_amount ELSE 0 END),2) AS [Reporting margin]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_reporting_amount ELSE 0 END),2)
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_reporting_amount ELSE 0 END),2) AS [Reporting net income]

		,ROUND(SUM (f.net_functional_amount),2) AS [Net functional amount]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_functional_amount ELSE 0 END),2)
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_functional_amount ELSE 0 END),2) AS [Functional margin]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_functional_amount ELSE 0 END),2)
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_functional_amount ELSE 0 END),2) AS [Functional net income]
		, 'Activity' AS [Source Type]
	FROM dbo.FT_GL_Account F --dbo.FLAT_JE f
		INNER JOIN dbo.v_Chart_of_accounts coa ON coa.coa_id = F.coa_id and coa.bu_id = f.bu_id
		INNER JOIN dbo.Parameters_period PP on pp.year_flag = f.year_flag and PP.period_flag = F.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL ON AUL.user_listing_id = F.approved_by_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	WHERE f.year_flag IN ('CY','PY') --WHERE f.audit_period != 'Subsequent' -- based on the new CDM - updated by Prabakar
	--and F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		coa.ey_account_type
		,coa.ey_account_class
		,f.ey_period
		,PP.year_flag_desc
		,PP.period_flag_desc
		,f.year_flag
		,f.period_flag
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,f.bu_group
		--,f.bu_ref
		,bu.bu_group
		,bu.bu_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,UL.preparer_ref
		,UL.department
		,AUL.department
		,AUL.preparer_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,f.segment1_ref
		--,f.segment2_ref
		--,f.segment1_group
		--,f.segment2_group
		--,f.source_group
		--,f.source_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group
		,src.source_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,f.sys_manual_ind
		,f.journal_type
		,COA.ey_account_group_I
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd

	UNION

		SELECT
			coa.ey_account_type AS [Account Type]
			,coa.ey_account_class AS [Account Class]

			--,f.ey_account_sub_type AS [Account Sub-type]
			--,f.ey_account_sub_class AS [Account Sub-class]
			--,f.gl_account_cd AS [GL Account]
			--,f.gl_account_name AS [GL Account Name]

			,coa.ey_account_group_I AS [Account group]
			,fc.fiscal_period_cd AS [Fiscal period]
			--,f.year_flag_desc AS [Accounting period]
			,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
					WHEN pp.year_flag ='PY' THEN 'Prior'
					WHEN pp.year_flag ='SP' THEN 'Subsequent'
					ELSE pp.year_flag_desc
			END AS [Accounting period]

			,pp.period_flag_desc AS [Accounting sub period]
			,pp.year_flag as [Year flag]
			,pp.period_flag as [Period flag]
			,bu.bu_group AS [Business unit group]
			,bu.bu_ref as [Business Unit]
			,'N/A for balances' AS [Preparer]
			,'N/A for balances' AS [Preparer department]
			,'N/A for balances' AS [Approver department]
			,'N/A for balances' AS [Approver]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			--,s1.segment_ref AS [Segment 1]
			--,s2.segment_ref AS [Segment 2]
			,s1.ey_segment_ref AS [Segment 1]
			,s2.ey_segment_ref AS [Segment 2]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,s1.ey_segment_group AS [Segment 1 group]
			,s2.ey_segment_group AS [Segment 2 group]
			,'N/A for balances' AS [Source group]
			,'N/A for balances' as [Source]
			--,f.sys_manual_ind as [Journal type]
			,'N/A for balances' as [Journal type]
			,tb.reporting_curr_cd AS [Reporting currency code]
			,tb.functional_curr_cd AS [Functional currency code]

			,ROUND(SUM (tb.reporting_ending_balance),2) AS [Net reporting amount]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.reporting_ending_balance ELSE 0 END),2)
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.reporting_ending_balance ELSE 0 END),2) AS [Reporting margin]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.reporting_ending_balance ELSE 0 END),2)
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.reporting_ending_balance ELSE 0 END),2) AS [Reporting net income]

			,ROUND(SUM (tb.functional_ending_balance),2) AS [Net functional amount]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.functional_ending_balance ELSE 0 END),2)
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.functional_ending_balance ELSE 0 END),2) AS [Functional margin]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.functional_ending_balance ELSE 0 END),2)
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.functional_ending_balance ELSE 0 END),2) AS [Functional net income]
			, 'Ending balance' AS [Source Type]
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

		WHERE fc.fiscal_period_seq IN (
											SELECT MAX(pp1.fiscal_period_seq_end)
											FROM dbo.Parameters_period pp1
											WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd and pp1.year_flag=pp.year_flag
							)
		AND pp.year_flag IN ('CY','PY')
		and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
		GROUP BY
			coa.ey_account_type
			,coa.ey_account_class
			,fc.fiscal_period_cd
			,pp.year_flag_desc
			,pp.period_flag_desc
			,pp.year_flag
			,pp.period_flag
			,bu.bu_group
			,bu.bu_ref
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			--,s1.segment_ref
			--,s2.segment_ref
			,s1.ey_segment_ref
			,s2.ey_segment_ref
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			,s1.ey_segment_group
			,s2.ey_segment_group
			,coa.ey_account_group_I
			,tb.reporting_curr_cd
			,tb.functional_curr_cd