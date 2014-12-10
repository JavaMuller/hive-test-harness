	Select
		--PP.year_flag_desc AS 'Accounting period'
		CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 
		,PP.Period_flag_desc 
		,F.year_flag 
		,F.period_flag 
		,F.ey_period 
		,C.ey_account_type 
		,C.ey_account_sub_type 
		,C.ey_account_class 
		,C.ey_account_sub_class 
		,C.gl_account_name 
		,C.gl_account_cd 
		,C.ey_gl_account_name 
		,c.ey_account_group_I 
		,Dp.preparer_ref 
		,DP.department 
		,DP1.department 
		,DP1.preparer_ref 

		,B.bu_group 
		,b.bu_ref 

		,s1.ey_segment_group 
		,s2.ey_segment_group 
		--Commented and added the dynamic view by prabakar on july 1st -- begin
		--,s1.segment_ref 
		--,s2.segment_ref 
		--,src.ey_source_group 

		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,src.source_group 
		--Commented and added the dynamic view by prabakar on july 1st -- END
		,src.source_Ref 
		--,f.sys_manual_ind AS 'Journal type'
		,f.journal_type 
		,f.reporting_amount_curr_cd 
		,f.functional_curr_cd AS   [Functional currency code]

		,sum(f.Net_reporting_amount) 
		,sum(f.Net_reporting_amount_credit) 
		,sum(f.Net_reporting_amount_debit) 

		,sum(f.Net_functional_amount) 
		,sum(f.Net_functional_amount_credit) 
		,sum(f.Net_functional_amount_debit) 
		, 'Activity' 

		-- Added 3 columns: Amod Oak on 6-26-2013
		, NULL 
		, NULL 
		, NULL 


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
		END 
		,pp.Period_flag_desc 
		,pp.year_flag 
		,pp.period_flag 
		,fc.fiscal_period_cd 
		,coa.ey_account_type 
		,coa.ey_account_sub_type 
		,coa.ey_account_class 
		,coa.ey_account_sub_class 
		,coa.gl_account_name 
		,coa.gl_account_cd 
		,coa.ey_gl_account_name 
		,coa.ey_account_group_I 
		,'N/A for balances' 
		,'N/A for balances'  
		,'N/A for balances'  
		,'N/A for balances'  

		,bu.bu_group 
		,bu.bu_ref 

		,s1.ey_segment_group 
		,s2.ey_segment_group 
		--Commented and added the dynamic view by prabakar on july 1st -- BEGIN
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		--Commented and added the dynamic view by prabakar on july 1st -- end
		,'N/A for balances'  
		,'N/A for balances'  

		,'N/A for balances'  
		,tb.reporting_curr_cd 
		,tb.functional_curr_cd AS   [Functional currency code]

		,tb.reporting_ending_balance 
		,0.0 
		,0.0 

		,tb.functional_ending_balance 
		,0.0 
		,0.0 
		, 'Balance' 

		-- Added 3 columns: Amod Oak on 6-26-2013
		, pp.end_date 
		, fc.fiscal_period_seq 
		, pp.fiscal_period_seq_END 


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