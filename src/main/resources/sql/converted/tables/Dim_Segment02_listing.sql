
CREATE TABLE [Dim_Segment02_listing]
(
[segment_id]				[int]						NOT NULL
,[engagement_id]			[uniqueidentifier]			NULL
,[segment_cd]				[nvarchar](25)				NULL
,[segment_desc]				[nvarchar](100)				NULL
,[segment_ref]				[nvarchar](125)				NULL
,[ey_segment_group]			[nvarchar](100)				NULL
,[ver_start_date_id]		[int]						NOT NULL
,[ver_end_date_id]			[int]						NULL
,[ver_desc]					[nvarchar](100)				NULL
) ON [PRIMARY]