CREATE TABLE [dbo].[Dim_Dates]
(
[calendar_date]				[datetime]					NULL
,[date_id]						[int]					NOT	NULL
,[month_id]						[int]						NULL
,[month_desc]					[nvarchar](100)				NULL
,[quarter_id]					[int]						NULL
,[quarter_desc]					[nvarchar](100)				NULL
,[year_id]						[int]						NULL
,[day_number_of_week]			[int]						NULL
,[day_of_week_desc]				[nvarchar](100)				NULL
,[day_number_of_month]			[int]						NULL
,[day_number_of_year]			[int]						NULL
,[week_number_of_year]			[int]						NULL

) ON [PRIMARY]