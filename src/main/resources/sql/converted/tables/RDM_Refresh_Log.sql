CREATE TABLE	[RDM_Refresh_Log]
(
row_counter				INT				NOT NULL IDENTITY(1,1)
,data_refresh_counter		INT				NOT NULL
,stream_name				NVARCHAR(100)	NULL
,test_name					NVARCHAR(200)	NULL
,executable_name			NVARCHAR(200)	NULL
,event_status				NVARCHAR(50)	NULL
,event_date_time			DATETIME		NULL
,error_msg					NVARCHAR(MAX)	NULL
)