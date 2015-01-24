	SELECT
		s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref  AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,coa.ey_account_class as [Account Class]
		,coa.ey_account_sub_class as [Account Sub-class]
		,coa.gl_account_cd as [GL code]
		,coa.gl_account_name as [GL account name]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I as [Account group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business Unit Group]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_group END AS [Source group]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_ref END AS [Source]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.preparer_ref END AS [Preparer]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.department END AS [Preparer department]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.department END AS [Approver department]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.preparer_ref END  AS [Approver]

		,CASE WHEN FJ.year_flag = 'CY' THEN 'Current'
			WHEN FJ.year_flag = 'PY' THEN 'Prior'
			WHEN FJ.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc END	AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,fj.year_flag AS [Year flag]
		,fj.period_flag  AS [Period flag]
		,FJ.EY_period as [Fiscal period]
		,fj.journal_type AS [Journal type]
		,fj.reporting_curr_cd AS [Reporting currency code]
		,fj.functional_curr_cd AS [Functional currency code]
		,source_type as [Source Type]


		,current_amount AS [Current Amount]
		,prior_amount AS [Prior Amount]
		,count_of_je_line_items  as [# of JE Line Items]
		,count_of_manual_je_lines  as [# of Manual JE Lines]
		,manual_amount as [Manual Amount ($)]
		,manual_functional_amount as [Manual Functional Amount]
		,count_ofdistinct_preparers  as [# of Distinct Preparers]
		,total_debit_activity  as [Total Debit Activity]
		,largest_line_item as [Largest Line Item]
		,largest_functional_line_item AS [Largest functional line item]
		,total_credit_activity  as [Total Credit Activity]
		,net_reporting_amount  AS [Net reporting amount]
		,net_reporting_amount_credit AS [Net reporting amount credit]
		,net_reporting_amount_debit AS [Net reporting amount debit]
		,net_functional_amount AS [Net functional amount]
		,net_functional_amount_credit AS [Net functional amount credit]
		,net_functional_amount_debit AS [Net functional amount debit]
		,functional_ending_balance  AS [Functional ending balance]
		,reporting_ending_balance AS [Reporting ending balance]
		,net_functional_amount_current AS [Net functional amount current]
		,net_functional_amount_prior AS [Net functional amount prior]
		,net_reporting_amount_current AS [Net reporting amount current]
		,net_reporting_amount_prior AS [Net reporting amount prior]

	FROM dbo.[GL_007_Significant_Acct] FJ
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.Parameters_period pp on pp.year_flag = fj.year_flag and PP.period_flag = fj.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = fj.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = FJ.approved_by_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fj.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
