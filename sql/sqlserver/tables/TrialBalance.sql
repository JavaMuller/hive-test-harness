
CREATE TABLE [dbo].[TrialBalance]
(
					 [coa_id]									[int]						NOT	NULL
					,[bu_id]									[int]						NOT	NULL
					,[period_id]								[int]						NOT	NULL
					,[segment1_id]								[int]							NULL
					,[segment2_id]								[int]							NULL
					,[engagement_id]							[nvarchar](100)					NULL
					,[trial_balance_start_date_id]				[int]							NULL
					,[trial_balance_end_date_id]				[int]							NULL
					,[functional_beginning_balance]				[float]							NULL
					,[functional_ending_balance]				[float]							NULL
					,[functional_curr_cd]						[nvarchar](8)					NULL
					,[beginning_balance]						[float]							NULL
					,[ending_balance]							[float]							NULL
					,[balance_curr_cd]							[nvarchar](8)					NULL
					,[reporting_beginning_balance]				[float]							NULL
					,[reporting_ending_balance]					[float]							NULL
					,[reporting_curr_cd]						[nvarchar](8)					NULL
					,[ver_start_date_id]						[int]							NULL
					,[ver_end_date_id]							[int]							NULL
					,[ver_desc]									[nvarchar](100)					NULL
) ON [PRIMARY]