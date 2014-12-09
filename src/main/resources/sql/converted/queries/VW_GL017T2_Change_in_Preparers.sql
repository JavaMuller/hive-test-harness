		cp.year_flag_desc AS [Accounting period]
		,cp.period_flag_desc AS [Accounting sub period]
		,cp.year_flag AS [Year flag]
		,cp.period_flag AS [Period Flag]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,bu_group AS [Business unit group]
		--,bu_ref AS [Business unit]
		--,segment1_ref AS [Segement 1]
		--,segment2_ref AS [Segement 2]
		--,segment1_group AS [Segment 1 group]
		--,segment2_group AS [Segment 2 group]
		--,source_group AS [Source group]
		--,Source_ref AS [Source]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref AS [Business unit]
		,s1.ey_segment_ref AS [Segement 1]
		,s2.ey_segment_ref AS [Segement 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,src.source_group AS [Source group]
		,src.Source_ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		,cp.Ey_period AS [Fiscal period]

		--,sys_manual_ind AS [Journal type]
		,cp.Journal_type AS [Journal type]
		,cp.preparer_ref AS [Preparer]
		,cp.department AS [Preparer department]
		,cp.reporting_amount_curr_cd		as	[Reporting currency code]
		,cp.functional_curr_cd		as	[Functional currency code]
		,cp.Category  AS [Category]

   FROM [dbo].GL_017_Change_in_Preparers CP
   /*  added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = cp.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = cp.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = cp.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = cp.segment2_id
	/*  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */