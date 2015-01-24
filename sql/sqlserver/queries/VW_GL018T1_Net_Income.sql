	SELECT

		COA.ey_account_type AS [Account Type]
		,COA.ey_account_class AS [Account Class]

		/* Below 4 columns wasn't presented in the original view any reason ??? */
		--,f.ey_account_sub_type AS [Account Sub-type]
		--,f.ey_account_sub_class AS [Account Sub-class]
		--,f.gl_account_cd AS [GL Account]
		--,f.gl_account_name AS [GL Account Name]

		,COA.ey_account_group_I	as	[Account group]
		,f.ey_period AS [Fiscal period]
		--,f.year_flag_desc AS [Accounting period]
		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END AS [Accounting period]

		,PP.period_flag_desc AS [Accounting sub period]
		,f.year_flag as [Year flag]
		,f.period_flag as [Period flag]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group AS [Business unit group]
		--,f.bu_ref as [Business Unit]
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_ref AS [Segment 2]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment2_group AS [Segment 2 group]
		--,f.source_group AS [Source group]
		--,f.source_ref as [Source]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,src.source_group AS [Source group]
		,src.source_ref as [Source]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,UL.preparer_ref AS [Preparer]
		,UL.department AS [Preparer department]
		,AUL.department AS [Approver department]
		,AUL.preparer_ref AS [Approver]

		--,f.sys_manual_ind as [Journal type]
		,f.journal_type as [Journal type]

		,f.reporting_amount_curr_cd AS [Reporting currency code]
		,f.functional_curr_cd AS [Functional currency code]
		--,SUM(CASE WHEN f.ey_account_type = 'Revenue' THEN f.reporting_amount ELSE 0 END) AS [Net reporting income]
		--,SUM(CASE WHEN f.ey_account_type = 'Revenue' THEN f.functional_amount ELSE 0 END) AS [Net functional income]

		,ROUND(SUM(CASE WHEN COA.ey_account_type = 'Revenue' THEN f.net_reporting_amount ELSE 0 END),2)
			- ROUND(SUM(CASE WHEN COA.ey_account_type = 'Expenses' THEN f.net_reporting_amount ELSE 0 END),2) AS [Net reporting income]
		,ROUND(SUM(CASE WHEN COA.ey_account_type = 'Revenue' THEN f.net_functional_amount ELSE 0 END),2)
			- ROUND(SUM(CASE WHEN COA.ey_account_type = 'Expenses' THEN f.net_functional_amount ELSE 0 END),2) AS [Net functional income]

	FROM dbo.FT_GL_Account F --dbo.FLAT_JE f
		INNER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = F.coa_id AND COA.bu_id = F.bu_id
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND pp.period_flag = f.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = f.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on UL.user_listing_id = f.approved_by_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	WHERE f.year_flag IN ('CY','PY')  --WHERE f.audit_period != 'Subsequent' -- based on the new CDM - updated by Prabakar
	--and F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		coa.ey_account_type
		,coa.ey_account_class
		,f.ey_period
		,PP.year_flag_desc
		,PP.period_flag_desc
		,f.year_flag
		,f.period_flag
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group
		--,f.bu_ref
		--,f.segment1_ref
		--,f.segment2_ref
		--,f.segment1_group
		--,f.segment2_group
		--,f.source_group
		--,f.source_ref
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group
		,src.source_ref

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,UL.preparer_ref
		,UL.department
		,AUL.department
		,AUL.preparer_ref

		--,f.sys_manual_ind
		,F.journal_type
		,COA.ey_account_group_I
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd