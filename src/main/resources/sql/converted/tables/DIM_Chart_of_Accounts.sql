
CREATE TABLE [DIM_Chart_of_Accounts]
(
[Coa_id]									[int]				NOT		NULL
,[bu_id]									[int]						NULL
,[coa_effective_date_id]					[int]						NULL
,[gl_account_cd]							[nvarchar](200)				NULL
,[gl_subacct_cd]							[nvarchar](200)				NULL
,[gl_account_name]							[nvarchar](200)				NULL
,[gl_subacct_name]							[nvarchar](200)				NULL
,[consolidation_account]					[nvarchar](200)				NULL
,[ey_gl_account_name]						[nvarchar](400)				NULL
,[ey_account_type]							[nvarchar](200)				NULL
,[ey_account_sub_type]						[nvarchar](200)				NULL
,[ey_account_class]							[nvarchar](200)				NULL
,[ey_account_sub_class]						[nvarchar](200)				NULL
,[ey_account_group_I]						[nvarchar](200)				NULL
,[ey_account_group_II]						[nvarchar](200)				NULL
,[ey_cash_activity]							[nvarchar](200)				NULL
,[ey_index]									[nvarchar](200)				NULL
,[ey_sub_index]								[nvarchar](200)				NULL
,[created_by_id]							[int]						NULL
,[created_date_id]							[int]						NULL
,[created_time_id]							[int]						NULL
,[last_modified_by_id]						[int]						NULL
,[last_modified_date_id]					[int]						NULL
,[ver_desc]									[nvarchar](200)				NULL
,[ver_start_date_id]						[int]						NULL
,[ver_end_date_id]							[int]						NULL

) ON [PRIMARY]
