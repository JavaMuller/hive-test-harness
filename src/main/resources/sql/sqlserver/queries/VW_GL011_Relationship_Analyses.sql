	Select
		--PP.year_flag_desc AS 'Accounting period'
		CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END AS [Accounting period]
		,PP.Period_flag_desc AS [Accounting sub period]
		,F.year_flag as [Year flag]
		,F.period_flag as [Period flag]
		,F.ey_period AS [Fiscal period]
		,C.ey_account_type AS [Account Type]
		,C.ey_account_sub_type AS [Account Sub-type]
		,C.ey_account_class AS [Account Class]
		,C.ey_account_sub_class AS [Account Sub-class]
		,C.gl_account_name AS [GL Account Name]
		,C.gl_account_cd AS [GL Account Cd]
		,C.ey_gl_account_name AS [GL Account]
		,c.ey_account_group_I as [Account Group]
		,Dp.preparer_ref AS [Preparer]
		,DP.department AS [Preparer department]
		,DP1.department AS [Approver department]
		,DP1.preparer_ref AS [Approver]

		,B.bu_group AS [Business unit group]
		,b.bu_ref AS [Business unit]

		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		--Commented and added the dynamic view by prabakar on july 1st -- begin
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		--,src.ey_source_group AS [Source group]

		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,src.source_group AS [Source group]
		--Commented and added the dynamic view by prabakar on july 1st -- END
		,src.source_Ref AS [Source]
		--,f.sys_manual_ind AS 'Journal type'
		,f.journal_type AS [Journal type]
		,f.reporting_amount_curr_cd AS [Reporting currency code]
		,f.functional_curr_cd AS   [Functional currency code]

		,sum(f.Net_reporting_amount) AS [Net reporting amount]
		,sum(f.Net_reporting_amount_credit) AS [Net reporting amount credit]
		,sum(f.Net_reporting_amount_debit) AS [Net reporting amount debit]

		,sum(f.Net_functional_amount) AS [Net functional amount]
		,sum(f.Net_functional_amount_credit) AS [Net functional amount credit]
		,sum(f.Net_functional_amount_debit) AS [Net functional amount debit]
		, 'Activity' AS [Source type]

		-- Added 3 columns: Amod Oak on 6-26-2013
		, NULL AS [Period end date]
		, NULL AS [Fiscal period sequence]
		, NULL AS [Fiscal period sequence end]


	FROM dbo.FT_GL_Account F --dbo.Ft_JE_Amounts F
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = f.year_flag
			AND PP.period_flag = f.period_flag
		INNER JOIN dbo.Dim_Preparer DP on DP.user_listing_id = f.user_listing_id
		LEFT OUTER JOIN dbo.Dim_Preparer DP1 on DP1.user_listing_id = f.approved_by_id
		--Commented and added the dynamic view by prabakar on july 1st -- begin
		--INNER JOIN dbo.dim_BU B on B.bu_id = F.bu_id
		--INNER JOIN dbo.Dim_Segment01_listing S1 on s1.segment_id = f.segment1_id
		--INNER JOIN dbo.Dim_Segment02_listing S2 on s2.segment_id = f.segment2_id
		--INNER JOIN dbo.dim_source_listing Src  on  Src.Source_Id = f.source_id
		LEFT OUTER  JOIN dbo.v_Business_unit_listing B on B.bu_id = F.bu_id
		LEFT OUTER  JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = f.segment1_id
		LEFT OUTER  JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = f.segment2_id
		LEFT OUTER  JOIN dbo.v_Source_listing Src  on  Src.Source_Id = f.source_id

		--Commented and added the dynamic view by prabakar on july 1st -- end
		INNER JOIN dbo.DIM_Chart_of_Accounts C on c.Coa_id = f.coa_id

	GROUP BY

		PP.year_flag_desc
		,PP.Period_flag_desc
		,F.year_flag
		,F.period_flag
		,F.ey_period
		,C.ey_account_type
		, C.ey_account_sub_type
		, C.ey_account_class
		, C.ey_account_sub_class
		, C.gl_account_name
		, C.gl_account_cd
		, C.ey_gl_account_name
		,c.ey_account_group_I
		,Dp.preparer_ref
		,DP.department
		,DP1.department
		,DP1.preparer_ref
		,B.bu_group
		,b.bu_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		--Commented and added the dynamic view by prabakar on july 1st -- BEGIN
		--,s1.segment_ref
		--,s2.segment_ref
		--,src.ey_source_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,src.source_group
		--Commented and added the dynamic view by prabakar on july 1st -- end
		,src.source_Ref
		--,f.sys_manual_ind
		,f.journal_type
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd

		/*
		Following UNION added by Amod Oak to reflect ending balances
		*/

UNION

	SELECT
	CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END AS [Accounting period]
		,pp.Period_flag_desc AS [Accounting sub period]
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,fc.fiscal_period_cd AS [Fiscal period]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_name AS [GL Account Name]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I as [Account Group]
		,'N/A for balances' AS [Preparer]
		,'N/A for balances'  AS [Preparer department]
		,'N/A for balances'  AS [Approver department]
		,'N/A for balances'  AS [Approver]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref AS [Business unit]

		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		--Commented and added the dynamic view by prabakar on july 1st -- BEGIN
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		--Commented and added the dynamic view by prabakar on july 1st -- end
		,'N/A for balances'  AS [Source group]
		,'N/A for balances'  AS [Source]

		,'N/A for balances'  AS [Journal type]
		,tb.reporting_curr_cd AS [Reporting currency code]
		,tb.functional_curr_cd AS   [Functional currency code]

		,tb.reporting_ending_balance AS [Net reporting amount]
		,0.0 AS [Net reporting amount credit]
		,0.0 AS [Net reporting amount debit]

		,tb.functional_ending_balance AS [Net functional amount]
		,0.0 AS [Net functional amount credit]
		,0.0 AS [Net functional amount debit]
		, 'Balance' AS [Source type]

		-- Added 3 columns: Amod Oak on 6-26-2013
		, pp.end_date AS [Period end date]
		, fc.fiscal_period_seq AS [Fiscal period sequence]
		, pp.fiscal_period_seq_END AS [Fiscal period sequence end]


		-- Changed FROM clause: Amod Oak on 6-26-2013
	FROM dbo.TrialBalance tb
		INNER JOIN DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			AND tb.bu_id = fc.bu_id
		INNER JOIN Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd

		--Commented and added the dynamic view by prabakar on july 1st -- begin
		--INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER  JOIN dbo.v_Business_unit_listing Bu on Bu.bu_id = tb.bu_id
		LEFT OUTER  JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER  JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		--Commented and added the dynamic view by prabakar on july 1st -- end
		where tb.ver_end_date_id IS NULL  -- Added by prabakar to pull the latest version of data on July 2nd
		AND
		(
			(
				(pp.period_flag = 'IP' OR pp.period_flag = 'PIP')
				--AND  fc.fiscal_period_seq <= pp.fiscal_period_seq_end
			)
			OR
			(
				(pp.period_flag = 'RP' OR pp.period_flag = 'PRP')
				--AND fc.fiscal_period_seq <= pp.fiscal_period_seq_end
				--AND fc.fiscal_period_seq > (
				--								SELECT MIN(pp1.fiscal_period_seq_end)
				--								FROM dbo.Parameters_period pp1
				--								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
				--								and pp1.year_flag = pp.year_flag
				--							)
			)
			OR (pp.period_flag = 'SP') --and fc.fiscal_period_seq < pp.fiscal_period_seq_end )
		)