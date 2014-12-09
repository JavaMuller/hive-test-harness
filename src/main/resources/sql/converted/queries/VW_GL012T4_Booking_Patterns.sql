	SELECT
		--COUNT(FJ.je_id) as [JE COUNT]
		--,COUNT(FJ.[je_line_id]) AS [Line Count]

		SUM(FJ.COUNT_JE_ID) as [JE COUNT]
		,SUM(FJ.COUNT_JE_ID) AS [Line Count]

		,ROUND(SUM(FJ.[net_amount]),2) as [Amount]
		,COA.[ey_account_class] AS [Account Class]
		,COA.ey_gl_account_name AS [GL Account]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,FJ.bu_ref	as [Business Unit]
		--,FJ.bu_group AS [Business unit group]
		--,FJ.segment1_group AS [Segment 1 group]
		--,FJ.segment1_ref AS [Segment 1]
		--,FJ.segment2_group  AS [Segment 2 group]
		--,FJ.segment2_ref  AS [Segment 2]
		--,FJ.source_group AS [Source group]
		--,FJ.source_ref AS [Source]

		,bu.bu_ref	as [Business Unit]
		,bu.bu_group AS [Business unit group]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group  AS [Segment 2 group]
		,s2.ey_segment_ref  AS [Segment 2]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,FJ.year_flag_desc AS [Accounting period]
		,CASE	WHEN FJ.year_flag ='CY' THEN 'Current'
				WHEN FJ.year_flag ='PY' THEN 'Prior'
				WHEN FJ.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END AS [Accounting period]

		,PP.period_flag_desc AS [Accounting sub period]
		,FJ.EY_period AS [Fiscal period]

		--,FJ.sys_manual_ind AS [Journal type]
		,FJ.journal_type AS [Journal type]
		,ul.department AS [Preparer department]
		,ul.preparer_ref as [Preparer]
		,aul.department AS [Approver department]
		,aul.preparer_ref AS [Approver]
		,FJ.functional_curr_cd as [Functional Currency Code]
		,FJ.reporting_amount_curr_cd AS [Reporting currency code]

		,FJ.journal_type as [System Manual Indicator]

		--,ROUND(SUM(FJ.functional_amount),2) AS [Functional Amount]
		--,ROUND(SUM(FJ.functional_credit_amount),2) AS [Functional Amount Credit]
		--,ROUND(SUM(FJ.functional_debit_amount),2) AS [Functional Amount Debit]

		,FJ.reversal_ind AS [Reversal indicator flag]  -- changed by Amod
		,CASE WHEN FJ.reversal_ind='Y' THEN 'Reversal'
			WHEN FJ.reversal_ind='N' THEN 'Non-Reversal'
			ELSE 'None'
		END AS [Reversal Indicator]



		,SUM(FJ.NET_reporting_amount) AS [Net reporting amount]
		,SUM(FJ.NET_reporting_amount_credit) AS [Net reporting amount credit]
		,SUM(FJ.NET_reporting_amount_debit) AS [Net reporting amount debit]

		,SUM(FJ.NET_functional_amount) AS [Net functional amount]
		,SUM(FJ.NET_functional_amount_credit) AS [Net functional amount credit]
		,SUM(FJ.NET_functional_amount_debit) AS [Net functional amount debit]


	FROM dbo.FT_GL_Account FJ--dbo.FLAT_JE FJ
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = FJ.coa_id and coa.bu_id = FJ.bu_id
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = fj.year_flag and PP.period_flag = FJ.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on ul.user_listing_id =FJ.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on Aul.user_listing_id = FJ.approved_by_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fJ.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fJ.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fJ.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fJ.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	--where FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		COA.ey_account_class
		,COA.ey_gl_account_name

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,FJ.bu_ref
		--,FJ.bu_group
		--,FJ.segment1_ref
		--,FJ.segment2_ref
		--,FJ.segment1_group
		--,FJ.segment2_group
		--,FJ.Source_ref
		--,FJ.source_group

		,bu.bu_ref
		,bu.bu_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.Source_ref
		,src.source_group
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,FJ.year_flag
		,fj.period_flag
		,PP.year_flag_desc
		,PP.period_flag_desc
		,FJ.EY_period
		--,FJ.sys_man_ind
		,FJ.journal_type
		,ul.department
		,ul.preparer_ref
		,aul.department
		,aul.preparer_ref
		,FJ.functional_curr_cd
		,FJ.reporting_amount_curr_cd

		,FJ.reversal_ind