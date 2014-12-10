CREATE TABLE [FLAT_JE]
(
ID												BIGINT IDENTITY(1,1)
,[je_id]										[nvarchar](100)							NOT NULL
,[je_line_id]									[nvarchar](100)							NOT NULL
,[je_line_desc]									[nvarchar](250)							NULL
,[je_header_desc]								[nvarchar](250)							NULL
,[dr_cr_ind]									[char](1)								NULL
,[coa_id]										[int]									NOT NULL
,[period_id]									[int]									NOT NULL
,[bu_id]										[int]									NOT NULL
,[source_id]									[int]									NOT NULL
,[segment1_id]									[int]									NULL
,[segment2_id]									[int]									NULL
--- Added for Feature purpose and populated from Journal Entires
,[segment3_id]									[int]									NULL
,[segment4_id]									[int]									NULL
,[segment5_id]									[int]									NULL

,[ey_je_id]										[nvarchar](100)							NULL
,[activity]										[nvarchar](100)							NULL
,[approved_by_id]								[int]									NULL
,[transaction_type_id]							[int]									NOT NULL
,[reversal_ind]									[char](1)								NULL
,[sys_manual_ind]								[char](1)								NULL
,[year_flag]									[nvarchar](25)							NULL
,[period_flag]									[nvarchar](25)							NULL
,[year_flag_desc]								[nvarchar](10)							NULL
,[period_flag_desc]								[nvarchar](100)							NULL
,[year_end_date]								[date]									NULL
,[period_end_date]								[date]									NULL
,[gl_account_cd]								[nvarchar](200)							NULL
,[gl_subacct_cd]								[nvarchar](200)							NULL
,[gl_account_name]								[nvarchar](200)							NULL
,[gl_subacct_name]								[nvarchar](200)							NULL
,[ey_gl_account_name]							[nvarchar](200)							NULL
,[consolidation_account]						[nvarchar](200)							NULL
,[ey_account_type]								[nvarchar](200)							NULL
,[ey_account_sub_type]							[nvarchar](200)							NULL
,[ey_account_class]								[nvarchar](200)							NULL
,[ey_cash_activity]								[nvarchar](200)							NULL
,[ey_account_sub_class]							[nvarchar](200)							NULL
,[ey_index]										[nvarchar](200)							NULL
,[ey_sub_index]									[nvarchar](200)							NULL
,[ey_account_group_I]							[nvarchar](200)							NULL
,[ey_account_group_II]							[nvarchar](200)							NULL
,[sys_manual_ind_src]							[char](1)								NULL
,[sys_manual_ind_usr]							[char](1)								NULL
,[user_listing_id]								[int]									NULL
,[client_user_id]								[nvarchar](25)							NULL
,[preparer_ref]									[nvarchar](200)							NULL
,[first_name]									[nvarchar](100)							NULL
,[last_name]									[nvarchar](100)							NULL
,[full_name]									[nvarchar](100)							NULL
,[department]									[nvarchar](100)							NULL
,[role_resp]									[nvarchar](100)							NULL
,[title]										[nvarchar](100)							NULL
,[active_ind]									[char](1)								NULL
-- commented below columns since it has to pull from cdm dyanmic view instead of storing by prabakar on july 01 -- begin
--,[source_cd]									[nvarchar](25)							NULL
--,[source_desc]									[nvarchar](100)							NULL
--,[source_ref]									[nvarchar](200)							NULL
--,[source_group]									[nvarchar](200)							NULL
--,[segment1_desc]								[nvarchar](100)							NULL
--,[segment2_desc]								[nvarchar](100)							NULL
--,[segment1_group]								[nvarchar](100)							NULL
--,[segment2_group]								[nvarchar](100)							NULL
--,[segment1_ref]									[nvarchar](125)							NULL
--,[segment2_ref]									[nvarchar](125)							NULL
--,[bu_cd]										[nvarchar](50)							NULL
--,[bu_desc]										[nvarchar](200)							NULL
--,[bu_ref]										[nvarchar](250)							NULL
--,[bu_group]										[nvarchar](200)							NULL
-- commented below columns since it has to pull from cdm dyanmic view instead of storing by prabakar on july 01 -- end
,[transaction_type_group_desc]					[nvarchar](100)							NULL
,[transaction_type]								[nvarchar](25)							NULL
,[fiscal_period_cd]								[nvarchar](50)							NOT NULL
,[fiscal_period_desc]							[nvarchar](100)							NULL
,[fiscal_period_start]							[nvarchar](50)							NOT NULL
,[fiscal_period_end]							[nvarchar](50)							NOT NULL
,[fiscal_quarter_start]							[nvarchar](50)							NULL
,[fiscal_quarter_end]							[nvarchar](50)							NULL
,[fiscal_year_start]							[nvarchar](50)							NULL
,[fiscal_year_end]								[nvarchar](50)							NULL
,[EY_fiscal_year]								[nvarchar](100)							NULL
,[EY_quarter]									[nvarchar](100)							NULL
,[EY_period]									[nvarchar](100)							NULL
,[Entry_Date]									[datetime]								NULL
,[Day_of_week]									[nvarchar](25)							NULL
,[Effective_Date]								[datetime]								NULL
,[Lag_Date]										[int]									NULL
,[exchange_rate]								[float]									NOT NULL
,[local_exchange_rate]							[float]									NOT NULL
,[reporting_exchange_rate]						[float]									NOT NULL
,[effective_date_id]							[int]									NOT NULL
,[entry_date_id]								[int]									NOT NULL
,[functional_curr_cd]							[nvarchar](25)							NOT NULL
,[functional_amount]							[float]									NOT NULL
,[functional_debit_amount]						[float]									NOT NULL
,[functional_credit_amount]						[float]									NOT NULL
,[amount]										[float]									NOT NULL
,[amount_debit]									[float]									NOT NULL
,[amount_credit]								[float]									NOT NULL
,[amount_curr_cd]								[nvarchar](25)							NOT NULL
,[reporting_amount]								[float]									NOT NULL
,[reporting_amount_curr_cd]						[nvarchar](25)							NOT NULL
,[reporting_amount_debit]						[float]									NOT NULL
,[reporting_amount_credit]						[float]									NOT NULL
,[engagement_id]								[uniqueidentifier]						NOT NULL
,[entry_time_id]								[int]									NOT NULL
,[last_modified_by_id]							[int]									NOT NULL
,[last_modified_date_id]						[int]									NOT NULL
,[approved_by_date_id]							[int]									NOT NULL
,[reversal_je_id]								[nvarchar](100)							NULL
,[GL_clearing_document]							[nvarchar](100)							NULL
,[GL_clearing_date_id]							[int]									NOT NULL
,[ver_start_date_id]							[int]									NOT NULL
,[ver_end_date_id]								[int]									NULL
,[ver_desc]										[nvarchar](100)							NULL
,[day_number_of_week]							[int]									NULL
,[day_number_of_month]							[int]									NULL
,journal_type									[nvarchar](25)							NULL
,[system_load_date]								[datetime]								NOT NULL
,[approver_department]							[nvarchar](250)							NULL
,[approver_ref]									[nvarchar](250)							NULL

,reporting_impact_to_assets						[float]									NULL
,reporting_impact_to_equity 						[float]									NULL
,reporting_impact_to_expenses 						[float]									NULL
,reporting_impact_to_liabilities 						[float]									NULL
,reporting_impact_to_revenue 						[float]									NULL
,functional_impact_to_assets 						[float]									NULL
,functional_impact_to_equity 						[float]									NULL
,functional_impact_to_expenses 						[float]									NULL
,functional_impact_to_liabilities 						[float]									NULL
,functional_impact_to_revenue 						[float]									NULL
-- Added below 4 by Prabakar as per the Tim Requirement to have for PTP and OTC -- Begin
,ey_subledger_type							[nvarchar](30)							NULL
,ey_AR_type									[nvarchar](30)							NULL
,ey_AP_type									[nvarchar](30)							NULL
,ey_reconciliation_GL_group					[nvarchar](30)							NULL
-- Added below 4 by Prabakar as per the Tim Requirement to have for PTP and OTC -- end
,Adjusted_fiscal_period						NVARCHAR(50)							NULL
) ON [PRIMARY]