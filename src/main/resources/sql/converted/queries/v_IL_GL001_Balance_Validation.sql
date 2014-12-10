	SELECT
		coa.ey_account_type 
		,bu.bu_ref 
		,bu.bu_group 

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,s1.ey_segment_group 
		,s2.ey_segment_group 

		,pp.year_flag 
		,pp.period_flag 
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag ='PY' THEN 'Prior'
			WHEN pp.year_flag ='SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc END 
		,pp.period_flag_desc 
		,pp.fiscal_period_seq_end 
		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 

		,SUM(tb.reporting_ending_balance) 
		,SUM(tb.functional_ending_balance) 
	FROM  dbo.TrialBalance tb

		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
			AND fc.fiscal_year_cd = pp.fiscal_year_cd

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

	where tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		coa.ey_account_type

		,bu.bu_ref
		,bu.bu_group

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,s1.segment_ref
		--,s2.segment_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,s1.ey_segment_group
		,s2.ey_segment_group

		,pp.year_flag
		,pp.period_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,pp.fiscal_period_seq_end
		,tb.reporting_curr_cd
		,tb.functional_curr_cd