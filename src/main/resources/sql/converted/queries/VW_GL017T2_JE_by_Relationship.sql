	SELECT
		--year_flag_desc	
		CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 
		,pp.period_flag_desc	
		,F.year_flag	
		,F.period_flag 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,F.bu_group	
		--,F.bu_ref	
		--,F.segment1_ref	
		--,F.segment2_ref	
		--,F.segment1_group 
		--,F.segment2_group 	
		--,F.source_group		
		--,F.Source_ref		
		,bu.bu_group	
		,bu.bu_ref	
		,s1.ey_segment_ref	
		,s2.ey_segment_ref	
		,s1.ey_segment_group 
		,s2.ey_segment_group 	
		,src.source_group		
		,src.Source_ref		
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,F.Ey_period		
		--,F.sys_manual_ind		
		,f.journal_type 
		,ul.preparer_ref 
		,ul.department		
		--,F.approver_department		
		--,F.approver_ref		
		,F.reporting_amount_curr_cd		
		,F.functional_curr_cd		
		,sum(f.count_je_id) 
		--,COUNT(F.je_id) 
		--,F.[audit_year]

	FROM dbo.FT_GL_Account F--dbo.Flat_JE F
	INNER JOIN dbo.Parameters_period PP on PP.year_flag  = f.year_flag AND PP.period_flag = F.period_flag
	LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = f.user_listing_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id
		--WHERE F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	GROUP BY
		pp.year_flag_desc
		,pp.period_flag_desc
		,F.year_flag
		,F.period_flag
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,F.bu_group
		--,F.bu_ref
		--,F.segment1_ref
		--,F.segment2_ref
		--,F.segment1_group
		--,F.segment2_group
		--,F.source_group
		--,F.Source_ref
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group
		,src.Source_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,F.Ey_period
		--,F.sys_manual_ind
		,f.journal_type
		,ul.preparer_ref
		,ul.department
		--,F.approver_department
		--,F.approver_ref
		,F.reporting_amount_curr_cd
		,F.functional_curr_cd