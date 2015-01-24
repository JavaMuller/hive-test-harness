	Select

		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,PP.year_flag  AS [Year flag]
		,PP.period_flag   AS [Period flag]
		,f.EY_period AS [Fiscal period]
		,f.coa_id	AS [Chart of account ID]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_name AS [GL Account Name]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I AS [Account Group]
		,ISNULL(F.user_listing_id,0)	AS		[Preparer ID]

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

		,f.sys_man_ind AS [EY system manual indicator]
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

	FROM dbo.GL_016_Balance_by_GL F
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id and coa.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = F.approved_by_id
		LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id
