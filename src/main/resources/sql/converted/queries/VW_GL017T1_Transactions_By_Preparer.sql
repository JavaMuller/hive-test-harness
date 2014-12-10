	SELECT
		F.EY_period 
		,coa.coa_id 
		,coa.ey_account_type 
		,coa.ey_account_sub_type 
		,coa.ey_account_class 
		,coa.ey_account_sub_class 
		,coa.gl_account_cd 
		,coa.ey_gl_account_name 
		,coa.ey_account_group_I 
		,UL.preparer_ref 
		,UL.department 
		--,F.sys_manual_ind 
		,F.journal_type 
		,AUL.preparer_ref 
		,AUL.department 
		/* commented and  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		--,F.source_ref 
		--,F.segment1_ref 
		--,F.segment2_ref 
		--,f.segment1_group 
		--,f.segment2_group 
		--,f.source_group 
		--,F.bu_ref 
		--,f.bu_group 
		,src.source_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,src.source_group 
		,bu.bu_ref 
		,bu.bu_group 
		/* commented and added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		--,f.transaction_type_group_desc 
		--,f.transaction_type 
		,f.year_flag 
		,f.period_flag 
		--,f.year_flag_desc 
		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 

		,pp.period_flag_desc 
		,F.reporting_amount_curr_cd		as	[Reporting currency code]
		,F.functional_curr_cd		as	[Functional currency code]
		--,count(F.je_id) 
		,sum(f.count_je_id) 
		,count(distinct F.user_listing_id) 
		--,count(F.je_line_id) 
		,sum(f.count_je_id)  
		,sum(F.net_reporting_amount_credit) 
		,sum(F.net_reporting_amount_debit) 
		,abs(sum(F.net_reporting_amount_credit))+abs(sum(F.net_reporting_amount_debit))   -- added round function by prabakartr may 19th
		,abs(sum(F.net_functional_amount_credit))+abs(sum(F.net_functional_amount_debit))  -- added functional_amount by Ashish May 20th


	FROM dbo.FT_GL_Account F --dbo.Flat_JE F
		INNER JOIN dbo.Parameters_period PP  on pp.period_flag = f.period_flag and PP.year_flag = F.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id and coa.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN DBO.v_User_listing AUL ON AUL.user_listing_id = f.approved_by_id
	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	--WHERE F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		F.EY_period
		,coa.coa_id
		,coa.ey_account_type
		,coa.ey_account_sub_type
		,coa.ey_account_class
		,coa.ey_account_sub_class
		,coa.gl_account_cd
		,coa.ey_gl_account_name
		,coa.ey_account_group_I
		,UL.preparer_ref
		,UL.department
		--,F.sys_manual_ind
		,F.journal_type
		,AUL.preparer_ref
		,AUL.department


		/* commented and added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,F.source_ref
		--,F.segment1_ref
		--,F.segment2_ref
		--,f.segment1_group
		--,f.segment2_group
		--,f.source_group
		--,F.bu_ref
		--,f.bu_group

		,src.source_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group
		,bu.bu_ref
		,bu.bu_group
		/* commented and added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		--,f.transaction_type_group_desc
		--,f.transaction_type
		,f.year_flag
		,f.period_flag
		,PP.year_flag_desc
		,PP.period_flag_desc
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd