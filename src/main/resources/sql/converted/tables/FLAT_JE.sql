CREATE TABLE
    [FLAT_JE]
    (
        ID BIGINT IDENTITY(1,1) ,
        [je_id] [nvarchar](100) NOT NULL ,
        [je_line_id] [nvarchar](100) NOT NULL ,
        [je_line_desc] [nvarchar](250) NULL ,
        [je_header_desc] [nvarchar](250) NULL ,
        [dr_cr_ind] [CHAR](1) NULL ,
        [coa_id] [INT] NOT NULL ,
        [period_id] [INT] NOT NULL ,
        [bu_id] [INT] NOT NULL ,
        [source_id] [INT] NOT NULL ,
        [segment1_id] [INT] NULL ,
        [segment2_id] [INT] NULL
        --- Added for Feature purpose and populated from Journal Entires
        ,
        [segment3_id] [INT] NULL ,
        [segment4_id] [INT] NULL ,
        [segment5_id] [INT] NULL ,
        [ey_je_id] [nvarchar](100) NULL ,
        [activity] [nvarchar](100) NULL ,
        [approved_by_id] [INT] NULL ,
        [transaction_type_id] [INT] NOT NULL ,
        [reversal_ind] [CHAR](1) NULL ,
        [sys_manual_ind] [CHAR](1) NULL ,
        [year_flag] [nvarchar](25) NULL ,
        [period_flag] [nvarchar](25) NULL ,
        [year_flag_desc] [nvarchar](10) NULL ,
        [period_flag_desc] [nvarchar](100) NULL ,
        [year_end_date] [DATE] NULL ,
        [period_end_date] [DATE] NULL ,
        [gl_account_cd] [nvarchar](200) NULL ,
        [gl_subacct_cd] [nvarchar](200) NULL ,
        [gl_account_name] [nvarchar](200) NULL ,
        [gl_subacct_name] [nvarchar](200) NULL ,
        [ey_gl_account_name] [nvarchar](200) NULL ,
        [consolidation_account] [nvarchar](200) NULL ,
        [ey_account_type] [nvarchar](200) NULL ,
        [ey_account_sub_type] [nvarchar](200) NULL ,
        [ey_account_class] [nvarchar](200) NULL ,
        [ey_cash_activity] [nvarchar](200) NULL ,
        [ey_account_sub_class] [nvarchar](200) NULL ,
        [ey_index] [nvarchar](200) NULL ,
        [ey_sub_index] [nvarchar](200) NULL ,
        [ey_account_group_I] [nvarchar](200) NULL ,
        [ey_account_group_II] [nvarchar](200) NULL ,
        [sys_manual_ind_src] [CHAR](1) NULL ,
        [sys_manual_ind_usr] [CHAR](1) NULL ,
        [user_listing_id] [INT] NULL ,
        [client_user_id] [nvarchar](25) NULL ,
        [preparer_ref] [nvarchar](200) NULL ,
        [first_name] [nvarchar](100) NULL ,
        [last_name] [nvarchar](100) NULL ,
        [full_name] [nvarchar](100) NULL ,
        [department] [nvarchar](100) NULL ,
        [role_resp] [nvarchar](100) NULL ,
        [title] [nvarchar](100) NULL ,
        [active_ind] [CHAR](1) NULL
        -- commented below columns since it has to pull from cdm dyanmic view instead of storing by
        -- prabakar on july 01 -- begin
        --,[source_cd]         [nvarchar](25)       NULL
        --,[source_desc]         [nvarchar](100)       NULL
        --,[source_ref]         [nvarchar](200)       NULL
        --,[source_group]         [nvarchar](200)       NULL
        --,[segment1_desc]        [nvarchar](100)       NULL
        --,[segment2_desc]        [nvarchar](100)       NULL
        --,[segment1_group]        [nvarchar](100)       NULL
        --,[segment2_group]        [nvarchar](100)       NULL
        --,[segment1_ref]         [nvarchar](125)       NULL
        --,[segment2_ref]         [nvarchar](125)       NULL
        --,[bu_cd]          [nvarchar](50)       NULL
        --,[bu_desc]          [nvarchar](200)       NULL
        --,[bu_ref]          [nvarchar](250)       NULL
        --,[bu_group]          [nvarchar](200)       NULL
        -- commented below columns since it has to pull from cdm dyanmic view instead of storing by
        -- prabakar on july 01 -- end
        ,
        [transaction_type_group_desc] [nvarchar](100) NULL ,
        [transaction_type] [nvarchar](25) NULL ,
        [fiscal_period_cd] [nvarchar](50) NOT NULL ,
        [fiscal_period_desc] [nvarchar](100) NULL ,
        [fiscal_period_start] [nvarchar](50) NOT NULL ,
        [fiscal_period_end] [nvarchar](50) NOT NULL ,
        [fiscal_quarter_start] [nvarchar](50) NULL ,
        [fiscal_quarter_end] [nvarchar](50) NULL ,
        [fiscal_year_start] [nvarchar](50) NULL ,
        [fiscal_year_end] [nvarchar](50) NULL ,
        [EY_fiscal_year] [nvarchar](100) NULL ,
        [EY_quarter] [nvarchar](100) NULL ,
        [EY_period] [nvarchar](100) NULL ,
        [Entry_Date] [DATETIME] NULL ,
        [Day_of_week] [nvarchar](25) NULL ,
        [Effective_Date] [DATETIME] NULL ,
        [Lag_Date] [INT] NULL ,
        [exchange_rate] [FLOAT] NOT NULL ,
        [local_exchange_rate] [FLOAT] NOT NULL ,
        [reporting_exchange_rate] [FLOAT] NOT NULL ,
        [effective_date_id] [INT] NOT NULL ,
        [entry_date_id] [INT] NOT NULL ,
        [functional_curr_cd] [nvarchar](25) NOT NULL ,
        [functional_amount] [FLOAT] NOT NULL ,
        [functional_debit_amount] [FLOAT] NOT NULL ,
        [functional_credit_amount] [FLOAT] NOT NULL ,
        [amount] [FLOAT] NOT NULL ,
        [amount_debit] [FLOAT] NOT NULL ,
        [amount_credit] [FLOAT] NOT NULL ,
        [amount_curr_cd] [nvarchar](25) NOT NULL ,
        [reporting_amount] [FLOAT] NOT NULL ,
        [reporting_amount_curr_cd] [nvarchar](25) NOT NULL ,
        [reporting_amount_debit] [FLOAT] NOT NULL ,
        [reporting_amount_credit] [FLOAT] NOT NULL ,
        [engagement_id] [uniqueidentifier] NOT NULL ,
        [entry_time_id] [INT] NOT NULL ,
        [last_modified_by_id] [INT] NOT NULL ,
        [last_modified_date_id] [INT] NOT NULL ,
        [approved_by_date_id] [INT] NOT NULL ,
        [reversal_je_id] [nvarchar](100) NULL ,
        [GL_clearing_document] [nvarchar](100) NULL ,
        [GL_clearing_date_id] [INT] NOT NULL ,
        [ver_start_date_id] [INT] NOT NULL ,
        [ver_end_date_id] [INT] NULL ,
        [ver_desc] [nvarchar](100) NULL ,
        [day_number_of_week] [INT] NULL ,
        [day_number_of_month] [INT] NULL ,
        journal_type [nvarchar](25) NULL ,
        [system_load_date] [DATETIME] NOT NULL ,
        [approver_department] [nvarchar](250) NULL ,
        [approver_ref] [nvarchar](250) NULL ,
        reporting_impact_to_assets [FLOAT] NULL ,
        reporting_impact_to_equity [FLOAT] NULL ,
        reporting_impact_to_expenses [FLOAT] NULL ,
        reporting_impact_to_liabilities [FLOAT] NULL ,
        reporting_impact_to_revenue [FLOAT] NULL ,
        functional_impact_to_assets [FLOAT] NULL ,
        functional_impact_to_equity [FLOAT] NULL ,
        functional_impact_to_expenses [FLOAT] NULL ,
        functional_impact_to_liabilities [FLOAT] NULL ,
        functional_impact_to_revenue [FLOAT] NULL
        -- Added below 4 by Prabakar as per the Tim Requirement to have for PTP and OTC -- Begin
        ,
        ey_subledger_type [nvarchar](30) NULL ,
        ey_AR_type [nvarchar](30) NULL ,
        ey_AP_type [nvarchar](30) NULL ,
        ey_reconciliation_GL_group [nvarchar](30) NULL
        -- Added below 4 by Prabakar as per the Tim Requirement to have for PTP and OTC -- end
        ,
        Adjusted_fiscal_period NVARCHAR(50) NULL
    )
