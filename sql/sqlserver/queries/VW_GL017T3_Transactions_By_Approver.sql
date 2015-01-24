	Select
		F.ey_period AS [Fiscal Period]
		--,F.sys_manual_ind AS [Journal Type]
		,F.journal_type AS [Journal Type]
		--, F.ey_account_type AS [Account Type]
		--, F.ey_account_sub_type AS [Account Sub-type]
		--, F.ey_account_class AS [Account Class]
		--, F.ey_account_sub_class AS [Account Sub-class]
		--, F.gl_account_cd AS [Account Code]
		--, F.ey_gl_account_name AS [GL Account]
		--,F.ey_account_group_I	as 	[Account group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,F.segment1_group AS [Segment 1 Group]
		--,F.segment2_group AS [Segment 2 Group]
		--,F.source_group AS [Source group]
		--,F.source_ref AS [Source]
		--,F.bu_ref AS [Business Unit]
		--,F.bu_group AS [Business Unit Group]
		--,F.segment1_ref AS [Segment 1]
		--,F.segment2_ref AS [Segment 2]

		,s1.ey_segment_group AS [Segment 1 Group]
		,s2.ey_segment_group AS [Segment 2 Group]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business Unit Group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,F.transaction_type_group_desc as [Transaction type group]
		--,F.transaction_type as [Transaction type]

		,UL.preparer_ref AS [Preparer]
		,UL.department AS [Preparer department]
		,AUL.preparer_ref AS [Approver]
		,AUL.department as [Approver department]

		,F.year_flag as [Year flag]
		,F.period_flag as [Period flag]
		--,F.year_flag_desc as [Accounting period]
		,CASE	WHEN F.year_flag ='CY' THEN 'Current'
				WHEN F.year_flag ='PY' THEN 'Prior'
				WHEN F.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc
		END AS [Accounting period]

		,PP.period_flag_desc as [Accounting sub period]
		,F.reporting_amount_curr_cd		as	[Reporting currency code]
		,F.functional_curr_cd		as	[Functional currency code]

		,SUM(F.net_reporting_amount_debit) AS [Credit Amount]
		,SUM(F.net_reporting_amount_debit) AS [Debit Amount]
		,ABS(SUM(F.net_reporting_amount_debit))+ABS(SUM(F.net_reporting_amount_debit)) AS [Net Amount]  -- added round function by prabakartr may 19th
		,ABS(SUM(F.net_functional_amount_credit))+ABS(SUM(F.net_functional_amount_debit)) AS [Functional Amount] -- added functional_amount by Ashish May 20th

		--, count(F.je_id) AS [Count of JE ID]
		--, count(distinct F.user_listing_id) AS [Count of distinct Preparers]
		--, count(F.je_line_id) AS [Count of JE Line ID]


	FROM dbo.FT_GL_Account F --dbo.Flat_JE F
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = F.approved_by_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--where F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		F.ey_period
		--,F.sys_man_ind
		,F.journal_type

		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group
		,src.source_ref
		,bu.bu_ref
		,bu.bu_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,F.transaction_type_group_desc
		--,F.transaction_type

		,UL.preparer_ref
		,UL.department
		,AUL.preparer_ref
		,AUL.department

		,F.year_flag
		,F.period_flag
		,PP.year_flag_desc
		,PP.period_flag_desc
		,F.reporting_amount_curr_cd
		,F.functional_curr_cd
