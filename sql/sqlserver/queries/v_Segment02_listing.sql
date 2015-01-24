WITH SEGMENT_CTE
AS
(
SELECT
'Segment01'		AS		table_identifier
,SL.segment_id
,SL.segment_cd
,SL.segment_desc
,SL.ey_segment_group
FROM			 [dbo].[Segment01_listing] SL
UNION ALL
SELECT
'Segment02'		AS		table_identifier
,SL.segment_id
,SL.segment_cd
,SL.segment_desc
,SL.ey_segment_group
FROM			 [dbo].[Segment02_listing] SL
UNION ALL
SELECT
'Segment03'		AS		table_identifier
,SL.segment_id
,SL.segment_cd
,SL.segment_desc
,SL.ey_segment_group
FROM			 [dbo].[Segment03_listing] SL
UNION ALL
SELECT
'Segment04'		AS		table_identifier
,SL.segment_id
,SL.segment_cd
,SL.segment_desc
,SL.ey_segment_group
FROM			 [dbo].[Segment04_listing] SL
UNION ALL
SELECT
'Segment05'		AS		table_identifier
,SL.segment_id
,SL.segment_cd
,SL.segment_desc
,SL.ey_segment_group
FROM			 [dbo].[Segment05_listing] SL
)

SELECT
   CASE WHEN SEGMENT.table_identifier = 'Segment01' THEN	SEGMENT.segment_id END	AS Segment01
  ,CASE WHEN SEGMENT.table_identifier = 'Segment02' THEN	SEGMENT.segment_id END	AS Segment02
  ,CASE WHEN SEGMENT.table_identifier = 'Segment03' THEN	SEGMENT.segment_id END	AS Segment03
  ,CASE WHEN SEGMENT.table_identifier = 'Segment04' THEN	SEGMENT.segment_id END	AS Segment04
  ,CASE WHEN SEGMENT.table_identifier = 'Segment05' THEN	SEGMENT.segment_id END	AS Segment05
  ,SEGMENT.segment_id AS ey_segment_id
  ,SEGMENT.segment_cd
  ,SEGMENT.segment_desc
  ,SEGMENT.ey_segment_group
  ,SEGMENT.segment_cd + ' - ' + SEGMENT.segment_desc AS ey_segment_ref  --Added by prabakar on June 25th for GL purpose
FROM				 SEGMENT_CTE SEGMENT
  INNER JOIN			 [dbo].[Parameters_engagement] PE		ON		SEGMENT.table_identifier = PE.segment_selection2
