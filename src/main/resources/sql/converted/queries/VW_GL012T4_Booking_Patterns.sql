	SELECT
		--COUNT(FJ.je_id) 
		--,COUNT(FJ.[je_line_id]) 

		SUM(FJ.COUNT_JE_ID) 
		,SUM(FJ.COUNT_JE_ID) 

		,ROUND(SUM(FJ.[net_amount]),2) 
		,COA.[ey_account_class] 
		,COA.ey_gl_account_name 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,FJ.bu_ref	
		--,FJ.bu_group 
		--,FJ.segment1_group 
		--,FJ.segment1_ref 
		--,FJ.segment2_group  
		--,FJ.segment2_ref  
		--,FJ.source_group 
		--,FJ.source_ref 

		,bu.bu_ref	
		,bu.bu_group 
		,s1.ey_segment_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_group  
		,s2.ey_segment_ref  
		,src.source_group 
		,src.source_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,FJ.year_flag_desc 
		,CASE	WHEN FJ.year_flag ='CY' THEN 'Current'
				WHEN FJ.year_flag ='PY' THEN 'Prior'
				WHEN FJ.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 

		,PP.period_flag_desc 
		,FJ.EY_period 

		--,FJ.sys_manual_ind 
		,FJ.journal_type 
		,ul.department 
		,ul.preparer_ref 
		,aul.department 
		,aul.preparer_ref 
		,FJ.functional_curr_cd 
		,FJ.reporting_amount_curr_cd 

		,FJ.journal_type 

		--,ROUND(SUM(FJ.functional_amount),2) 
		--,ROUND(SUM(FJ.functional_credit_amount),2) 
		--,ROUND(SUM(FJ.functional_debit_amount),2) 

		,FJ.reversal_ind   -- changed by Amod
		,CASE WHEN FJ.reversal_ind='Y' THEN 'Reversal'
			WHEN FJ.reversal_ind='N' THEN 'Non-Reversal'
			ELSE 'None'
		END 



		,SUM(FJ.NET_reporting_amount) 
		,SUM(FJ.NET_reporting_amount_credit) 
		,SUM(FJ.NET_reporting_amount_debit) 

		,SUM(FJ.NET_functional_amount) 
		,SUM(FJ.NET_functional_amount_credit) 
		,SUM(FJ.NET_functional_amount_debit) 


	FROM dbo.FT_GL_Account FJ--dbo.FLAT_JE FJ
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = FJ.coa_id and coa.bu_id = FJ.bu_id
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = fj.year_flag and PP.period_flag = FJ.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on ul.user_listing_id =FJ.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on Aul.user_listing_id = FJ.approved_by_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fJ.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fJ.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fJ.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fJ.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	--where FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		COA.ey_account_class
		,COA.ey_gl_account_name

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,FJ.bu_ref
		--,FJ.bu_group
		--,FJ.segment1_ref
		--,FJ.segment2_ref
		--,FJ.segment1_group
		--,FJ.segment2_group
		--,FJ.Source_ref
		--,FJ.source_group

		,bu.bu_ref
		,bu.bu_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.Source_ref
		,src.source_group
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,FJ.year_flag
		,fj.period_flag
		,PP.year_flag_desc
		,PP.period_flag_desc
		,FJ.EY_period
		--,FJ.sys_man_ind
		,FJ.journal_type
		,ul.department
		,ul.preparer_ref
		,aul.department
		,aul.preparer_ref
		,FJ.functional_curr_cd
		,FJ.reporting_amount_curr_cd

		,FJ.reversal_ind