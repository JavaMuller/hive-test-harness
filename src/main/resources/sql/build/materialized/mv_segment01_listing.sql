CREATE TABLE
    mv_segment01_listing
    (
        segment01 INT,
        segment02 INT,
        segment03 INT,
        segment04 INT,
        segment05 INT,
        ey_segment_id INT,
        segment_cd string,
        segment_desc string,
        ey_segment_group string,
        ey_segment_ref string
    ) ;

WITH
    SEGMENT_CTE AS
    (
     SELECT
            'Segment01' AS table_identifier,
            SL.segment_id,
            SL.segment_cd,
            SL.segment_desc,
            SL.ey_segment_group
       FROM
            Segment01_listing SL
  UNION ALL
     SELECT
            'Segment02' AS table_identifier,
            SL.segment_id,
            SL.segment_cd,
            SL.segment_desc,
            SL.ey_segment_group
       FROM
            Segment02_listing SL
  UNION ALL
     SELECT
            'Segment03' AS table_identifier,
            SL.segment_id,
            SL.segment_cd,
            SL.segment_desc,
            SL.ey_segment_group
       FROM
            Segment03_listing SL
  UNION ALL
     SELECT
            'Segment04' AS table_identifier,
            SL.segment_id,
            SL.segment_cd,
            SL.segment_desc,
            SL.ey_segment_group
       FROM
            Segment04_listing SL
  UNION ALL
     SELECT
            'Segment05' AS table_identifier,
            SL.segment_id,
            SL.segment_cd,
            SL.segment_desc,
            SL.ey_segment_group
       FROM
            Segment05_listing SL
    )
INSERT
    overwrite TABLE mv_segment01_listing
SELECT
    CASE
        WHEN SEGMENT.table_identifier = 'Segment01'
        THEN SEGMENT.segment_id
    END AS Segment01,
    CASE
        WHEN SEGMENT.table_identifier = 'Segment02'
        THEN SEGMENT.segment_id
    END AS Segment02,
    CASE
        WHEN SEGMENT.table_identifier = 'Segment03'
        THEN SEGMENT.segment_id
    END AS Segment03,
    CASE
        WHEN SEGMENT.table_identifier = 'Segment04'
        THEN SEGMENT.segment_id
    END AS Segment04,
    CASE
        WHEN SEGMENT.table_identifier = 'Segment05'
        THEN SEGMENT.segment_id
    END AS Segment05,
    SEGMENT.segment_id AS ey_segment_id,
    SEGMENT.segment_cd,
    SEGMENT.segment_desc,
    SEGMENT.ey_segment_group,
    concat ( SEGMENT.segment_cd, ' - ', SEGMENT.segment_desc ) AS ey_segment_ref
FROM
    SEGMENT_CTE SEGMENT
INNER JOIN
    Parameters_engagement PE
 ON
    SEGMENT.table_identifier = PE.segment_selection1;
