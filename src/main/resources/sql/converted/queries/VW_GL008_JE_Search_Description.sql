SELECT
  Journal_entry_id,
  Journal_entry_line,
  Journal_line_description,
  Journal_entry_description,
  Journal_entry_type,
  ul.preparer_ref,
  ul.department,
  SL.source_ref,
  SL.source_group,
  bu.bu_ref,
  bu.bu_group,
  SG1.ey_segment_group,
  SG2.ey_segment_group,
  SG1.ey_segment_ref,
  SG2.ey_segment_ref,
  PP.period_flag_desc,
  FT_GL.ey_period,
  CASE
  WHEN FT_GL.year_flag = 'CY'
  THEN 'Current'
  WHEN FT_GL.year_flag = 'PY'
  THEN 'Prior'
  WHEN FT_GL.year_flag = 'SP'
  THEN 'Subsequent'
  ELSE PP.year_flag_desc
  END
FROM
  dbo.GL_008_JE_Search FT_GL
  INNER JOIN
  dbo.Parameters_period PP
    ON
      PP.period_flag = FT_GL.period_flag
      AND PP.year_flag = FT_GL.year_flag
  LEFT OUTER JOIN
  dbo.v_User_listing ul
    ON
      ul.user_listing_id = FT_GL.user_listing_id
  LEFT OUTER JOIN
  dbo.v_Business_unit_listing bu
    ON
      FT_GL.bu_id = bu.bu_id
  LEFT OUTER JOIN
  dbo.v_Source_listing SL
    ON
      FT_GL.source_id = SL.source_id
  LEFT OUTER JOIN
  dbo.v_Segment01_listing SG1
    ON
      SG1.ey_segment_id = FT_GL.segment1_id
  LEFT OUTER JOIN
  dbo.v_Segment02_listing SG2
    ON
      SG2.ey_segment_id = FT_GL.segment2_id