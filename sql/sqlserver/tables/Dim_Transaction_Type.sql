CREATE TABLE [dbo].[Dim_Transaction_Type]
(
[transaction_type_id]					[int]							NOT NULL
,[transaction_type_cd]					[nvarchar](25)					NOT NULL
,[bu_id]								[int]							NOT NULL
,[engagement_id]						[uniqueidentifier]				NOT NULL
,[transaction_type_desc]				[nvarchar](100)					NULL
,[transaction_type_group_desc]			[nvarchar](100)					NULL
,[EY_transaction_type]					[nvarchar](25)					NULL
,[entry_by_id]							[int]							NULL
,[entry_date_id]						[int]							NOT NULL
,[entry_time_id]						[int]							NOT NULL
,[last_modified_by_id]					[int]							NOT NULL
,[last_modified_date_id]				[int]							NOT NULL
,[ver_start_date_id]					[int]							NOT NULL
,[ver_end_date_id]						[int]							NULL
,[ver_desc]								[nvarchar](100)					NULL
,[transaction_type_ref]					[nvarchar](125)					NULL
) ON [PRIMARY]