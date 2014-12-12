CREATE VIEW
  v_segment02_listing AS
WITH
  SEGMENT_CTE AS
  (
  SELECT
  'Segment01' AS table_identifier,
  segment_id,
  segment_cd,
  segment_desc,
  ey_segment_group
  FROM
  Segment01_listing SL
  UNION ALL
  SELECT
  'Segment02' AS table_identifier,
  segment_id,
  segment_cd,
  segment_desc,
  ey_segment_group
  FROM
  Segment02_listing SL
  UNION ALL
  SELECT
  'Segment03' AS table_identifier,
  segment_id,
  segment_cd,
  segment_desc,
  ey_segment_group
  FROM
  Segment03_listing SL
  UNION ALL
  SELECT
  'Segment04' AS table_identifier,
  segment_id,
  segment_cd,
  segment_desc,
  ey_segment_group
  FROM
  Segment04_listing SL
  UNION ALL
  SELECT
  'Segment05' AS table_identifier,
  segment_id,
  segment_cd,
  segment_desc,
  ey_segment_group
  FROM
  Segment05_listing
  )
SELECT
  CASE
  WHEN table_identifier = 'Segment01'
  THEN segment_id
  END AS Segment01,
  CASE
  WHEN table_identifier = 'Segment02'
  THEN segment_id
  END AS Segment02,
  CASE
  WHEN table_identifier = 'Segment03'
  THEN segment_id
  END AS Segment03,
  CASE
  WHEN table_identifier = 'Segment04'
  THEN segment_id
  END AS Segment04,
  CASE
  WHEN table_identifier = 'Segment05'
  THEN segment_id
  END AS Segment05,
  segment_id AS ey_segment_id,
  segment_cd,
  segment_desc,
  ey_segment_group,
  segment_cd + ' - ' + segment_desc AS ey_segment_ref
FROM
  SEGMENT_CTE
  INNER JOIN
  Parameters_engagement PE
    ON
      table_identifier = PE.segment_selection2;