CREATE TABLE [RDM_Refresh_Executables]
(
row_counter				INT				NOT NULL IDENTITY(1,1)
,Sequence					INT				NULL
,sp_name					NVARCHAR(500)	NOT NULL
,sp_id						INT				NULL
,refresh_stream				NVARCHAR(50)	NULL
,level						INT				NULL
)