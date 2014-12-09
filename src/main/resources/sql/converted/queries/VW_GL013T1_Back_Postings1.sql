	SELECT
		fj.coa_id AS [Coa Id]
		,fj.ey_account_type AS [Account Type]
		,fj.ey_account_sub_type AS [Account Sub-type]
		,fj.ey_account_class AS [Account Class]
		,fj.ey_account_sub_class AS [Account Sub-class]
		,fj.gl_account_cd AS [GL Account Cd]
		,fj.gl_account_name AS [GL Account Name]
		,fj.ey_gl_account_name	 AS [GL Account]
		,fj.bu_id AS [BU Id]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,fj.bu_ref AS [Business unit]
		--,fj.bu_group AS [Business unit group]
		--,fj.segment1_id AS [Segment 1 Id]
		--,fj.segment1_ref AS [Segment 1]
		--,fj.segment1_group AS [Segment 1 group]
		--,fj.segment2_id AS [Segment 2 Id]
		--,fj.segment2_ref AS [Segment 2]
		--,fj.segment2_group AS [Segment 2 group]
		,bu.bu_ref AS [Business unit]
		,bu.bu_group AS [Business unit group]
		,fj.segment1_id AS [Segment 1 Id]
		,s1.ey_segment_ref AS [Segment 1]
		,s1.ey_segment_group AS [Segment 1 group]
		,fj.segment2_id AS [Segment 2 Id]
		,s2.ey_segment_ref AS [Segment 2]
		,s2.ey_segment_group AS [Segment 2 group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		,fj.functional_curr_cd AS [Functional Currency Code]
		,fj.reporting_amount_curr_cd AS [Reporting currency code]
		,fj.period_flag  AS [Period flag]
		,fj.year_flag AS [Year flag]
		,CASE WHEN fj.year_flag = 'CY' THEN 'Current'
			WHEN fj.year_flag = 'PY' THEN 'Prior'
			WHEN fj.year_flag = 'SP' THEN 'Subsequent'
			ELSE fj.year_flag_Desc
		END AS [Accounting period]
		,fj.period_flag_desc AS [Accounting sub period]
		,SUM(functional_amount) AS [Net functional amount]
		,SUM(reporting_amount) AS [Net reporting amount]
		,fj.ver_end_date_id AS [Version end date Id]
		,fj.ver_desc AS [Version description]
		,'Backposting activity' AS [Source type]
	FROM dbo.flat_je fj
	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fj.bu_id
		--LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fj.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

	WHERE fj.period_flag = 'IP'
	AND fj.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
	GROUP BY
		fj.coa_id
		,fj.gl_account_cd
		,fj.gl_account_name
		,fj.ey_gl_account_name
		,fj.bu_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,fj.bu_ref
		--,fj.bu_group
		--,fj.segment1_id
		--,fj.segment1_ref
		--,fj.segment1_group
		--,fj.segment2_id
		--,fj.segment2_ref
		--,fj.segment2_group

		,bu.bu_ref
		,bu.bu_group
		,fj.segment1_id
		,s1.ey_segment_ref
		,s1.ey_segment_group
		,fj.segment2_id
		,s2.ey_segment_ref
		,s2.ey_segment_group

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,fj.functional_curr_cd
		,fj.reporting_amount_curr_cd
		,fj.period_flag
		,fj.year_flag
		,fj.year_flag_desc
		,fj.ver_end_date_id
		,fj.ver_desc
		,fj.ey_account_type
		,fj.ey_account_sub_type
		,fj.ey_account_class
		,fj.ey_account_sub_class
		,period_flag_desc

	UNION

	SELECT
		tb.coa_id AS [Coa Id]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.gl_account_name AS [GL Account Name]
		,coa.ey_gl_account_name AS [GL Account]
		,tb.bu_id AS [BU Id]
		,bu.bu_ref AS [Business unit]
		,bu.bu_group AS [Business unit group]
		,tb.segment1_id AS [Segment 1 Id]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,s1.segment_ref AS [Segment 1]
		,s1.ey_segment_ref  AS [Segment 1]
		,s1.ey_segment_group AS [Segment 1 group]
		,tb.segment2_id AS [Segment 2 Id]
		--,s2.segment_ref AS [Segment 2]
		,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,s2.ey_segment_group AS [Segment 2 group]
		,tb.functional_curr_cd AS [Functional Currency Code]
		,tb.reporting_curr_cd AS [Reporting currency code]
		,pp.period_flag  AS [Period flag]
		,pp.year_flag  AS [Year flag]
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag = 'PY' THEN 'Prior'
			WHEN pp.year_flag = 'SP' THEN 'Subsequent'
		ELSE pp.year_flag_desc
		END AS [Accounting period]
		,pp.period_flag_desc AS [Accounting sub period]
		,tb.functional_beginning_balance +  ag.net_functional_amount as [Net functional amount]
		,tb.reporting_beginning_balance + ag.net_reporting_amount as [Net reporting amount]
		,NULL AS [Version end date Id]
		,NULL AS [Version description]
		,'Interim as posted' AS [Source type]
	FROM dbo.TrialBalance tb
		FULL OUTER JOIN
		(
			SELECT
				fj.coa_id
				,fj.gl_account_cd
				,fj.gl_account_name
				,fj.ey_gl_account_name
				,fj.bu_id
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				--,fj.bu_ref AS [Business unit]
				--,fj.bu_group AS [Business unit group]
				--,fj.segment1_id AS [Segment 1 Id]
				--,fj.segment1_ref AS [Segment 1]
				--,fj.segment1_group AS [Segment 1 group]
				--,fj.segment2_id AS [Segment 2 Id]
				--,fj.segment2_ref AS [Segment 2]
				--,fj.segment2_group AS [Segment 2 group]
				,bu.bu_ref AS [Business unit]
				,bu.bu_group AS [Business unit group]
				,fj.segment1_id AS [Segment 1 Id]
				,s1.ey_segment_ref AS [Segment 1]
				,s1.ey_segment_group AS [Segment 1 group]
				,fj.segment2_id AS [Segment 2 Id]
				,s2.ey_segment_ref AS [Segment 2]
				,s2.ey_segment_group AS [Segment 2 group]
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				,fj.functional_curr_cd
				,fj.reporting_amount_curr_cd
				,fj.period_flag
				,fj.year_flag
				,fj.year_flag_desc
				,fj.ver_end_date_id
				,fj.ver_desc
				,SUM(functional_amount) AS net_functional_amount
				,SUM(reporting_amount) AS net_reporting_amount
			FROM dbo.flat_je fj
				/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fj.bu_id
				--LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fj.source_id
				LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
				LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
				/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			WHERE fj.period_flag = 'IP'
			AND fj.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
			GROUP BY
				fj.coa_id
				,fj.gl_account_cd
				,fj.gl_account_name
				,fj.ey_gl_account_name
				,fj.bu_id
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				--,fj.bu_ref
				--,fj.bu_group
				--,fj.segment1_id
				--,fj.segment1_ref
				--,fj.segment1_group
				--,fj.segment2_id
				--,fj.segment2_ref
				--,fj.segment2_group

				,bu.bu_ref
				,bu.bu_group
				,fj.segment1_id
				,s1.ey_segment_ref
				,s1.ey_segment_group
				,fj.segment2_id
				,s2.ey_segment_ref
				,s2.ey_segment_group
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
				,fj.functional_curr_cd
				,fj.reporting_amount_curr_cd
				,fj.period_flag
				,fj.year_flag
				,fj.year_flag_desc
				,fj.ver_end_date_id
				,fj.ver_desc
			) ag ON ag.coa_id = tb.coa_id
			AND ag.bu_id = tb.bu_id
			-- Since Possible that Segment info may be be null in TrialBalance -- prabakar
			--AND ag.segment1_id = tb.segment1_id
			--AND ag.segment2_id = tb.segment2_id
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
			AND fc.fiscal_year_cd = pp.fiscal_year_cd

		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.dim_bu bu ON tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = tb.segment2_id
		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */


	WHERE pp.period_flag = 'IP'
	AND tb.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
	UNION

	SELECT
		tb.coa_id AS [Coa Id]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.gl_account_name AS [GL Account Name]
		,coa.ey_gl_account_name AS [GL Account]
		,tb.bu_id AS [BU Id]
		,bu.bu_ref AS [Business unit]
		,bu.bu_group AS [Business unit group]
		,tb.segment1_id AS [Segment 1 Id]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,s1.segment_ref AS [Segment 1]
		,s1.ey_segment_ref AS [Segment 1]
		,s1.ey_segment_group AS [Segment 1 group]
		,tb.segment2_id AS [Segment 2 Id]
		--,s2.segment_ref AS [Segment 2]
		,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,s2.ey_segment_group AS [Segment 2 group]
		,tb.functional_curr_cd AS [Functional Currency Code]
		,tb.reporting_curr_cd AS [Reporting currency code]
		,pp.period_flag  AS [Period flag]
		,pp.year_flag  AS [Year flag]
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag = 'PY' THEN 'Prior'
			WHEN pp.year_flag = 'SP' THEN 'Subsequent'
		ELSE pp.year_flag_desc END AS [Accounting period]
		,pp.period_flag_desc AS [Accounting sub period]
		,tb.functional_ending_balance AS [Net functional amount]
		,tb.reporting_ending_balance AS [Net reporting amount]
		,NULL AS [Version end date Id]
		,NULL AS [Version description]
		,'Interim as shown' AS [Source type]
	FROM dbo.TrialBalance tb

		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
			AND fc.fiscal_year_cd = pp.fiscal_year_cd

		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.dim_bu bu ON tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = tb.segment2_id
		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	WHERE pp.period_flag = 'IP'
	AND tb.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
