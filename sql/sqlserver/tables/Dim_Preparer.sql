CREATE TABLE [dbo].[Dim_Preparer]
(
[user_listing_id]					[int]					NOT	NULL
,[client_user_id]					[nvarchar](25)				NULL
,[first_name]						[nvarchar](100)				NULL
,[last_name]						[nvarchar](100)				NULL
,[full_name]						[nvarchar](100)				NULL
,[preparer_ref]						[nvarchar](200)				NULL
,[department]						[nvarchar](100)				NULL
,[title]							[nvarchar](100)				NULL
,[role_resp]						[nvarchar](100)				NULL
,[sys_manual_ind]					[char](1)					NULL
,[active_ind]						[char](1)					NULL
,[active_ind_change_date_id]		[int]						NULL
,[created_by_id]					[int]						NULL
,[created_date_id]					[int]						NULL
,[created_time_id]					[int]						NULL
,[last_modified_by_id]				[int]						NULL
,[last_modified_date_id]			[int]						NULL
,[ver_start_date_id]				[int]						NULL
,[ver_end_date_id]					[int]						NULL

) ON [PRIMARY]
