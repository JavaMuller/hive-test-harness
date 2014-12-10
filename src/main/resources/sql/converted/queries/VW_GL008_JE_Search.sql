SELECT
    FT_GL.Journal_entry_id ,
    FT_GL.Journal_entry_line ,
    FT_GL.Journal_entry_description ,
    FT_GL.Journal_entry_type ,
    FT_GL.Journal_line_description ,
    ul.preparer_ref AS [Preparer] ,
    ul.department   AS [Preparer department] ,
    SL.source_ref ,
    SL.source_group AS [Source GROUP] ,
    bu.bu_ref ,
    bu.bu_group ,
    SG1.ey_segment_group AS [Segment 1 GROUP] ,
    SG2.ey_segment_group AS [Segment 2 GROUP] ,
    SG1.ey_segment_ref   AS [Segment 1] ,
    SG2.ey_segment_ref   AS [Segment 2] ,
    PP.period_flag_desc  AS [Accounting sub period] ,
    FT_GL.ey_period      AS [Fiscal period] ,
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