	SELECT
		Journal_entry_id AS [Journal Entry Id]
		,Journal_entry_line  AS [Journal Entry Line]
		,Journal_line_description  AS [Journal Line Description]  -- added by prabakar on july 28
		,Journal_entry_description  AS [Journal Entry Description]
		,Journal_entry_type AS [Journal Entry Type]
		,ul.preparer_ref as   [Preparer]
		,ul.department as  [Preparer department]
		,SL.source_ref  as [Source]
		,SL.source_group  as  [Source group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business unit group]
		,SG1.ey_segment_group as  [Segment 1 group]
		,SG2.ey_segment_group as  [Segment 2 group]
		,SG1.ey_segment_ref as  [Segment 1]
		,SG2.ey_segment_ref as  [Segment 2]
		,PP.period_flag_desc as  [Accounting sub period]
		,FT_GL.ey_period as  [Fiscal period]
		,CASE WHEN FT_GL.year_flag = 'CY' THEN 'Current'
			WHEN FT_GL.year_flag = 'PY' THEN 'Prior'
			WHEN FT_GL.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc
		END  as [Accounting period]

	FROM dbo.GL_008_JE_Search FT_GL
	INNER JOIN dbo.Parameters_period PP on PP.period_flag = FT_GL.period_flag AND PP.year_flag = FT_GL.year_flag
	LEFT OUTER JOIN dbo.v_User_listing ul on ul.user_listing_id = FT_GL.user_listing_id
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on FT_GL.bu_id = bu.bu_id
	LEFT OUTER JOIN dbo.v_Source_listing SL on FT_GL.source_id = SL.source_id
	LEFT OUTER JOIN dbo.v_Segment01_listing SG1 on SG1.ey_segment_id = FT_GL.segment1_id
	LEFT OUTER JOIN dbo.v_Segment02_listing SG2 on SG2.ey_segment_id = FT_GL.segment2_id