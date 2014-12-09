	Select
		C.ey_account_type AS [Account Type]
		,C.ey_account_sub_type AS [Account Sub-type]
		,C.ey_account_class AS [Account Class]
		,C.ey_account_sub_class AS [Account Sub-class]
		,C.gl_account_name AS [GL Account Name]
		,C.gl_account_cd AS [GL Account Cd]
		,C.ey_gl_account_name AS [GL Account]
		,C.ey_account_group_I as [Account Group]

		,F.year_flag as [Year flag]
		,F.period_flag as [Period flag]
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag = 'PY' THEN 'Prior'
			WHEN pp.year_flag = 'SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc END as  [Accounting period]
		,pp.period_flag_desc as  [Accounting sub period]
		,F.ey_period as  [Fiscal period]

		,Dp.preparer_ref AS [Preparer]
		,Dp.department as [Preparer department]
		,Dp1.department AS [Approver department]
		,Dp1.preparer_ref AS [Approver]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,Src.source_ref AS [Source]
		--,Src.ey_source_group as  [Source group]
		,src.source_group as  [Source group]
		--,S1.segment_ref as [Segment 1]
		,s1.ey_segment_ref as [Segment 1]
		,S1.ey_segment_group as  [Segment 1 group]
		--,S2.segment_ref as [Segment 2]
		,s2.ey_segment_ref as [Segment 2]
		,S2.ey_segment_group as  [Segment 2 group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		,Bu.bu_group as  [Business unit group]
		,Bu.bu_ref as  [Business unit]

		--,F.sys_manual_ind as [Journal type]
		,F.journal_type as [Journal type]

		,F.reporting_amount_curr_cd as  [Reporting currency code]
		,F.functional_curr_cd AS [Functional Currency Code]

		,SUM(F.Net_reporting_amount) as  [Net reporting amount]
		,SUM (Case When c.ey_account_type = 'Revenue' THEN F.Net_reporting_amount ELSE 0 End) AS [Net reporting sales]
		,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.Net_reporting_amount ELSE 0 End) AS [Net reporting cost of sales]
		,SUM(F.Net_reporting_amount_credit) as  [Net reporting credit amount]
		,SUM(F.Net_reporting_amount_debit) as  [Net reporting debit amount]

		,SUM(F.Net_functional_amount) as  [Net functional amount]
		,SUM (Case When c.ey_account_type = 'Revenue' THEN F.Net_functional_amount ELSE 0 End) AS [Net functional sales]
		,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.Net_functional_amount ELSE 0 End) AS [Net functional cost of sales]

		,sum(F.Net_functional_amount_credit) as  [Net functional credit amount]
		,sum(F.Net_functional_amount_debit) as  [Net functional debit amount]

		--,F.seg1_ref_id AS 'Segment 1 desc'  -- Need to map with segment1_listing
		--,F.seg2_ref_id AS 'Segment 2 desc' -- Need to map with segment2_listing
		--,sum(F.functional_amount) AS 'Amount in Functional Currency'
		--,SUM (Case When Pa.EY_GL_Account_group = 'Revenue' THEN F.functional_amount ELSE 0 End) AS 'Sales in Functional Currency'
		--,SUM (Case When Pa.EY_GL_Account_group = 'Cost of sales' THEN F.functional_amount ELSE 0 End) AS 'Cost of Sales in Functional Currency'

		/*COMMENTED AS PER DISCUSSION WITH SPOTFIRE 6-5
		--,sum(F.net_amount) AS 'Net Amount'
		--,SUM (Case When c.ey_account_type = 'Revenue' THEN F.[net_amount] ELSE 0 End) AS 'Sales'
		--,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.[net_amount] ELSE 0 End) AS 'Cost of Sales'
		--,SUM (Case When c.ey_account_type = 'Revenue' THEN F.Net_functional_amount ELSE 0 End) AS 'Sales in Functional Currency'
		--,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.Net_functional_amount ELSE 0 End) AS 'Cost of Sales in Functional Currency'
		COMMENTED AS PER DISCUSSION WITH SPOTFIRE*/

	FROM dbo.FT_GL_Account F --dbo.Ft_JE_Amounts F
		INNER JOIN dbo.Dim_Chart_of_Accounts C ON F.coa_id = C.coa_id
		INNER JOIN dbo.Dim_Preparer Dp ON Dp.user_listing_id = F.user_listing_id
		INNER JOIN dbo.Dim_Preparer Dp1 ON Dp1.user_listing_id = F.approved_by_id
		INNER JOIN dbo.Parameters_period PP ON pp.year_flag = F.year_flag
				AND pp.period_flag	 = F.period_flag

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.dim_BU Bu ON F.bu_id = Bu.bu_id
		--INNER JOIN dbo.Dim_Segment01_listing S1 ON S1.segment_id = F.segment1_id
		--INNER JOIN dbo.Dim_Segment02_listing s2 ON S2.segment_id = F.segment2_id
		--INNER JOIN dbo.dim_source_listing Src ON F.source_id = Src.source_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		--WHERE ey_gl_account_group IN ('Revenue','Cost of sales')

	GROUP BY
		 C.ey_account_type
		,C.ey_account_sub_type
		,C.ey_account_class
		,C.ey_account_sub_class
		,C.gl_account_name
		,C.gl_account_cd
		,C.ey_gl_account_name
		,c.ey_account_group_I
		,F.year_flag
		,F.period_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,F.ey_period
		,Dp.preparer_ref
		,Dp.department
		,Dp1.department
		,Dp1.preparer_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,Src.source_ref
		--,Src.ey_source_group
		,src.source_group
		,S1.ey_segment_group
		,S2.ey_segment_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		--,S1.segment_ref
		--,S2.segment_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,Bu.bu_group
		,Bu.bu_ref
		--,F.sys_manual_ind
		,f.journal_type
		,F.reporting_amount_curr_cd
		,F.functional_curr_cd
		,pp.year_flag