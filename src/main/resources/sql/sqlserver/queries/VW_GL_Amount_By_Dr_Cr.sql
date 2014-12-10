SELECT
	COA.ey_account_type AS [Account Type]
	,COA.ey_account_sub_type AS [Account Sub-type]
	,COA.ey_account_class AS [Account Class]
	,COA.ey_account_sub_class AS [Account Sub-class]
	,COA.gl_account_cd AS [GL Account Cd]
	,COA.gl_account_name AS [GL Account Name]
	,COA.ey_account_group_I   AS [Account group]
	,COA.ey_account_group_II AS [Account sub group]
	,COA.ey_gl_account_name AS [GL Account]
	,FT_GL.[dr_cr_ind]  AS [Indicator]
	,ul.preparer_ref as   [Preparer]
	,ul.department as  [Preparer department]
	,SL.source_ref  as [Source]
	,SL.source_group  as  [Source group]
	,bu.bu_ref AS [Business Unit]
	,bu.bu_group AS [Business unit group]
	,SG1.ey_segment_group as  [Segment 1 group]
	,SG2.ey_segment_group as  [Segment 2 group]
	,SG1.ey_segment_ref as  [Segment 1]
	,SG2.ey_segment_ref as  [Segment 2]

	,FT_GL.year_flag as [Year flag]
	,FT_GL.period_flag as [Period flag]

	,CASE WHEN FT_GL.year_flag = 'CY' THEN 'Current'
			WHEN FT_GL.year_flag = 'PY' THEN 'Prior'
			WHEN FT_GL.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc
		END  as [Accounting period]
	,PP.period_flag_desc as  [Accounting sub period]
	,FT_GL.ey_period as  [Fiscal period]


	,FT_GL.Sys_man_ind  AS [System Manual Indicator]
	--,FT_GL.sys_manual_ind as 'Journal type'
	,FT_GL.journal_type as [Journal type]
	,FT_GL.reporting_amount_curr_cd as [Reporting currency code]

	,FT_GL.functional_curr_cd AS [Functional Currency Code]
	,SUM(FT_GL.net_amount) AS [Net Amount]
	--,FT_GL.functional_amount  AS [Functional Amount]
	,SUM(FT_GL.net_reporting_amount) as [Net reporting amount]
	,SUM(FT_GL.net_reporting_amount_credit) as [Net reporting credit amount]
	,SUM(FT_GL.net_reporting_amount_debit) as [Net reporting debit amount]
	,SUM(FT_GL.net_functional_amount) as [Net functional amount]
	,SUM(FT_GL.net_functional_amount_credit) as [Net functional credit amount]
	,SUM(FT_GL.net_functional_amount_debit) as [Net functional debit amount]

FROM dbo.FT_GL_Account FT_GL
	INNER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = FT_GL.coa_id and COA.bu_id = FT_GL.bu_id
	LEFT OUTER JOIN dbo.Parameters_period PP on PP.period_flag = FT_GL.period_flag AND PP.year_flag = FT_GL.year_flag
	LEFT OUTER JOIN dbo.v_User_listing ul on ul.user_listing_id = FT_GL.user_listing_id
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on FT_GL.bu_id = bu.bu_id
	LEFT OUTER JOIN dbo.v_Source_listing SL on FT_GL.source_id = SL.source_id
	LEFT OUTER JOIN dbo.v_Segment01_listing SG1 on SG1.ey_segment_id = FT_GL.segment1_id
	LEFT OUTER JOIN dbo.v_Segment02_listing SG2 on SG2.ey_segment_id = FT_GL.segment2_id
GROUP by
	COA.ey_account_type
	,COA.ey_account_sub_type
	,COA.ey_account_class
	,COA.ey_account_sub_class
	,COA.gl_account_cd
	,COA.gl_account_name
	,COA.ey_account_group_I
	,COA.ey_account_group_II
	,COA.ey_gl_account_name
	,FT_GL.[dr_cr_ind]
	,UL.preparer_ref
	,UL.department
	,SL.source_ref
	,SL.source_group
	,bu.bu_ref
	,bu.bu_group
	,SG1.ey_segment_group
	,SG2.ey_segment_group
	,SG1.ey_segment_ref
	,SG2.ey_segment_ref

	,FT_GL.year_flag
	,FT_GL.period_flag

	,PP.year_flag_desc
	,PP.period_flag_desc
	,FT_GL.ey_period


	,FT_GL.Sys_man_ind

	,FT_GL.journal_type
	,FT_GL.reporting_amount_curr_cd

	,FT_GL.functional_curr_cd