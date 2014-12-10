	Select
		F.ey_period 
		--,F.sys_manual_ind 
		,F.journal_type 
		--, F.ey_account_type 
		--, F.ey_account_sub_type 
		--, F.ey_account_class 
		--, F.ey_account_sub_class 
		--, F.gl_account_cd 
		--, F.ey_gl_account_name 
		--,F.ey_account_group_I	as 	[Account group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,F.segment1_group 
		--,F.segment2_group 
		--,F.source_group 
		--,F.source_ref 
		--,F.bu_ref 
		--,F.bu_group 
		--,F.segment1_ref 
		--,F.segment2_ref 

		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,src.source_group 
		,src.source_ref 
		,bu.bu_ref 
		,bu.bu_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,F.transaction_type_group_desc 
		--,F.transaction_type 

		,UL.preparer_ref 
		,UL.department 
		,AUL.preparer_ref 
		,AUL.department 

		,F.year_flag 
		,F.period_flag 
		--,F.year_flag_desc 
		,CASE	WHEN F.year_flag ='CY' THEN 'Current'
				WHEN F.year_flag ='PY' THEN 'Prior'
				WHEN F.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc
		END 

		,PP.period_flag_desc 
		,F.reporting_amount_curr_cd		
		,F.functional_curr_cd		

		,SUM(F.net_reporting_amount_debit) 
		,SUM(F.net_reporting_amount_debit) 
		,ABS(SUM(F.net_reporting_amount_debit))+ABS(SUM(F.net_reporting_amount_debit))   -- added round function by prabakartr may 19th
		,ABS(SUM(F.net_functional_amount_credit))+ABS(SUM(F.net_functional_amount_debit))  -- added functional_amount by Ashish May 20th

		--, count(F.je_id) 
		--, count(distinct F.user_listing_id) 
		--, count(F.je_line_id) 


	FROM dbo.FT_GL_Account F --dbo.Flat_JE F
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = F.approved_by_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--where F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		F.ey_period
		--,F.sys_man_ind
		,F.journal_type

		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group
		,src.source_ref
		,bu.bu_ref
		,bu.bu_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,F.transaction_type_group_desc
		--,F.transaction_type

		,UL.preparer_ref
		,UL.department
		,AUL.preparer_ref
		,AUL.department

		,F.year_flag
		,F.period_flag
		,PP.year_flag_desc
		,PP.period_flag_desc
		,F.reporting_amount_curr_cd
		,F.functional_curr_cd
