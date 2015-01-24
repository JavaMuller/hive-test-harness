CREATE TABLE [dbo].[Ft_JE_Amounts]
(
					 [je_id]							[nvarchar](200)			NOT NULL
					,[coa_id]							[int]					NOT NULL
					,[period_id]						[int]					NOT NULL
					,[bu_id]							[int]					NOT NULL
					,[source_id]						[int]					NOT NULL
					,[user_listing_id]					[int]						NULL
					,[approved_by_id]					[int]						NULL
					,[segment1_id]						[int]						NULL
					,[segment2_id]						[int]						NULL
					,[dr_cr_ind]						[char](1)					NULL
					,[reversal_ind]						[char](1)					NULL
					,[sys_manual_ind]					[char](1)					NULL
					,Journal_type 					[nvarchar](25)				 NULL
					,[year_flag]						[char](50)					NULL
					,[period_flag]						[char](50)					NULL
					,[ey_period]						[nvarchar](200)				NULL
					,[entry_date_id]					[int]						NULL
					,[effective_date_id]				[int]						NULL
					,[Net_amount]						[float]						NULL
					,[Net_amount_debit]					[float]						NULL
					,[Net_amount_credit]				[float]						NULL
					,[amount_curr_cd]					[nvarchar](50)				NULL
					,[Net_reporting_amount]				[float]						NULL
					,[Net_reporting_amount_debit]		[float]						NULL
					,[Net_reporting_amount_credit]		[float]						NULL
					,[reporting_amount_curr_cd]			[nvarchar](50)				NULL
					,[Net_functional_amount]			[float]						NULL
					,[Net_functional_debit_amount]		[float]						NULL
					,[Net_functional_credit_amount]		[float]						NULL
					,[functional_amount_curr_cd]		[nvarchar](50)				NULL
					,[count_je_id]						INT							NULL
) ON [PRIMARY]