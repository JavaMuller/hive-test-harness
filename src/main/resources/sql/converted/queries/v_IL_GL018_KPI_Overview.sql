
	SELECT
		coa.ey_account_type AS 'Category'
		--,fj.fiscal_period_cd 
		,fj.ey_period 
		,CASE	WHEN fj.year_flag ='CY' THEN 'Current'
				WHEN fj.year_flag ='PY' THEN 'Prior'
				WHEN fj.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc
		END 
		,PP.period_flag_desc 
		,fj.year_flag 
		,fj.period_flag 

		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group 
		--,fj.bu_ref 
		--,fj.segment1_ref 
		--,fj.segment2_ref 
		--,fj.segment1_group 
		--,fj.segment2_group 

		,bu.bu_group 
		,bu.bu_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 

		--,src.source_group 
		--,src.source_ref	
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end

		,fj.reporting_amount_curr_cd 
		,fj.functional_curr_cd 
		,ROUND(SUM (fj.net_reporting_amount),2) 
		,ROUND(SUM (fj.net_functional_amount),2) 
		, 'Activity' 
		, pp.end_date 
		, NULL 
		, NULL 
		, NULL 
	FROM dbo.FT_GL_Account FJ --FLAT_JE fj
		INNER JOIN dbo.Parameters_period PP on pp.period_flag = fj.period_flag and PP.year_flag = FJ.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = FJ.bu_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = Fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = Fj.segment2_id
		--LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = fj.source_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july end
	WHERE fj.year_flag IN ('CY','PY')
	--and FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		coa.ey_account_type
		,fj.ey_period
		,fj.year_flag
		,pp.year_flag_desc
		,pp.period_flag_desc

		,fj.period_flag
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group
		--,fj.bu_ref
		--,fj.segment1_ref
		--,fj.segment2_ref
		--,fj.segment1_group
		--,fj.segment2_group
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group

		--,src.source_group
		--,src.source_ref
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end

		,fj.reporting_amount_curr_cd
		,fj.functional_curr_cd
		,PP.end_date

	UNION

	SELECT
		coa.ey_account_sub_type AS 'Category'
		,fj.ey_period 
		,CASE	WHEN fj.year_flag ='CY' THEN 'Current'
				WHEN fj.year_flag ='PY' THEN 'Prior'
				WHEN fj.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 
		,PP.period_flag_desc 
		,fj.year_flag 
		,fj.period_flag 
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group 
		--,fj.bu_ref 
		--,fj.segment1_ref 
		--,fj.segment2_ref 
		--,fj.segment1_group 
		--,fj.segment2_group 

		,bu.bu_group 
		,bu.bu_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 

		--,src.source_group 
		--,src.source_ref	
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd 
		,fj.functional_curr_cd 
		,ROUND(SUM (fj.net_reporting_amount),2) 
		,ROUND(SUM (fj.net_functional_amount),2) 
		, 'Activity' 
		, pp.end_date 
		, NULL 
		, NULL 
		, NULL 
	FROM dbo.FT_GL_Account FJ --FLAT_JE fj
		INNER JOIN dbo.Parameters_period PP on pp.period_flag = fj.period_flag and PP.year_flag = FJ.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = FJ.bu_id
	-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = Fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = Fj.segment2_id
		--LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = fj.source_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july end
	WHERE fj.year_flag IN ('CY','PY')
	--and FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		coa.ey_account_sub_type
		,fj.ey_period

		,fj.year_flag
		,fj.period_flag

		,pp.year_flag_desc
		,PP.period_flag_desc
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group
		--,fj.bu_ref
		--,fj.segment1_ref
		--,fj.segment2_ref
		--,fj.segment1_group
		--,fj.segment2_group
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group

		--,src.source_group
		--,src.source_ref
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd
		,fj.functional_curr_cd
		,pp.end_date

		UNION

		SELECT
		coa.ey_account_group_I AS 'Category'
		,fj.ey_period 
		,CASE	WHEN fj.year_flag ='CY' THEN 'Current'
				WHEN fj.year_flag ='PY' THEN 'Prior'
				WHEN fj.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc
		END 
		,PP.period_flag_desc 
		,fj.year_flag 
		,fj.period_flag 
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group 
		--,fj.bu_ref 
		--,fj.segment1_ref 
		--,fj.segment2_ref 
		--,fj.segment1_group 
		--,fj.segment2_group 

		,bu.bu_group 
		,bu.bu_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 

		--,src.source_group 
		--,src.source_ref	
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd 
		,fj.functional_curr_cd 
		,ROUND(SUM (fj.net_reporting_amount),2) 
		,ROUND(SUM (fj.net_functional_amount),2) 
		, 'Activity' 
		, pp.end_date 
		, NULL 
		, NULL 
		, NULL 
	FROM dbo.FT_GL_Account FJ --FLAT_JE fj
		INNER JOIN dbo.Parameters_period PP on pp.period_flag = fj.period_flag and PP.year_flag = FJ.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = FJ.bu_id
	-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = Fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = Fj.segment2_id
		--LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = fj.source_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july end
	WHERE fj.year_flag IN ('CY','PY')
	--and FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		coa.ey_account_group_I
		,fj.ey_period
		,fj.year_flag
		,pp.year_flag_desc
		,PP.period_flag_desc

		,fj.period_flag
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group
		--,fj.bu_ref
		--,fj.segment1_ref
		--,fj.segment2_ref
		--,fj.segment1_group
		--,fj.segment2_group
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group

		--,src.source_group
		--,src.source_ref
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd
		,fj.functional_curr_cd
		,pp.end_date

	UNION

	SELECT
		coa.ey_account_type AS 'Category'
		,fc.fiscal_period_cd 
		,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 
		,pp.period_flag_desc 
		,pp.year_flag 
		,pp.period_flag 
		,bu.bu_group 
		,bu.bu_ref 
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		--,'N/A Balances' 
		--,'N/A Balances'	

		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 
		,ROUND(SUM (tb.reporting_ending_balance),2) 
		,ROUND(SUM (tb.functional_ending_balance),2) 
		, 'Balance' 
		, pp.END_date 
		, fc.fiscal_period_seq 
		, pp.fiscal_period_seq_END 
		, fc.adjustment_period 
	FROM dbo.TrialBalance tb

		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd
		--	AND fc.fiscal_period_seq = pp.fiscal_period_seq_end

		-- commented and added table by prabakar on july 1st to refer rdm table -- begin
		--INNER JOIN  dbo.dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		-- commented and added table by prabakar on july 1st to refer rdm table -- end
	WHERE pp.year_flag IN ('CY','PY')
	and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	--AND fc.fiscal_period_seq = (
	--						SELECT MAX(pp1.fiscal_period_seq_end)
	--						FROM dbo.Parameters_period pp1
	--						WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
	--					)
	GROUP BY
		coa.ey_account_type
		,fc.fiscal_period_cd
		,pp.year_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,pp.period_flag
		,bu.bu_group
		,bu.bu_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref
		--,s2.segment_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group
		,s2.ey_segment_group
		,tb.reporting_curr_cd
		,tb.functional_curr_cd
		, pp.END_date
		, fc.fiscal_period_seq
		, pp.fiscal_period_seq_END
		, fc.adjustment_period

	UNION

	SELECT
		coa.ey_account_sub_type AS 'Category'
		,fc.fiscal_period_cd 
		,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 
		,pp.period_flag_desc 
		,pp.year_flag 
		,pp.period_flag 
		,bu.bu_group 
		,bu.bu_ref 
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		--,'N/A Balances' 
		--,'N/A Balances'	

		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 
		,ROUND(SUM (tb.reporting_ending_balance),2) 
		,ROUND(SUM (tb.functional_ending_balance),2) 
		, 'Balance' 
		, pp.END_date 
		, fc.fiscal_period_seq 
		, pp.fiscal_period_seq_END 
		, fc.adjustment_period 
	FROM dbo.TrialBalance tb

		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd
		--	AND fc.fiscal_period_seq = pp.fiscal_period_seq_end
		-- commented and added table by prabakar on july 1st to refer rdm table -- begin
		--INNER JOIN  dbo.dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		-- commented and added table by prabakar on july 1st to refer rdm table -- end
	WHERE pp.year_flag IN ('CY','PY')
	and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	--AND fc.fiscal_period_seq = (
	--						SELECT MAX(pp1.fiscal_period_seq_end)
	--						FROM dbo.Parameters_period pp1
	--						WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
	--					)
	GROUP BY
		coa.ey_account_sub_type
		,fc.fiscal_period_cd
		,pp.year_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,pp.period_flag
		,bu.bu_group
		,bu.bu_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref
		--,s2.segment_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group
		,s2.ey_segment_group
		,tb.reporting_curr_cd
		,tb.functional_curr_cd
		, pp.END_date
		, fc.fiscal_period_seq
		, pp.fiscal_period_seq_END
		, fc.adjustment_period

	UNION

		SELECT
		coa.ey_account_group_I AS 'Category'
		,fc.fiscal_period_cd 
		,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 
		,pp.period_flag_desc 
		,pp.year_flag 
		,pp.period_flag 
		,bu.bu_group 
		,bu.bu_ref 
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group 
		,s2.ey_segment_group 

		--,'N/A Balances' 
		--,'N/A Balances'	

		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 
		,ROUND(SUM (tb.reporting_ending_balance),2) 
		,ROUND(SUM (tb.functional_ending_balance),2) 
		, 'Balance' 
		, pp.END_date 
		, fc.fiscal_period_seq 
		, pp.fiscal_period_seq_END 
		, fc.adjustment_period 
	FROM dbo.TrialBalance tb

		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd
		--	AND fc.fiscal_period_seq = pp.fiscal_period_seq_end

		-- commented and added table by prabakar on july 1st to refer rdm table -- begin
		--INNER JOIN  dbo.dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		-- commented and added table by prabakar on july 1st to refer rdm table -- end

	WHERE pp.year_flag IN ('CY','PY')
	and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	--AND fc.fiscal_period_seq = (
	--						SELECT MAX(pp1.fiscal_period_seq_end)
	--						FROM dbo.Parameters_period pp1
	--						WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
	--					)
	GROUP BY
		coa.ey_account_group_I
		,fc.fiscal_period_cd
		,pp.year_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,pp.period_flag
		,bu.bu_group
		,bu.bu_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref
		--,s2.segment_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group
		,s2.ey_segment_group
		,tb.reporting_curr_cd
		,tb.functional_curr_cd
		, pp.END_date
		, fc.fiscal_period_seq
		, pp.fiscal_period_seq_END
		, fc.adjustment_period
