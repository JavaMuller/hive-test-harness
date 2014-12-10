CREATE TABLE
    [GL_016_Balance_by_GL]
    (
        coa_id INT NULL,
        bu_id INT NULL,
        source_id INT NULL,
        segment1_id INT NULL,
        segment2_id INT NULL,
        user_listing_id INT NULL,
        approved_by_id INT NULL,
        year_flag NVARCHAR(25) NULL,
        period_flag NVARCHAR(25) NULL,
        ey_period NVARCHAR(50) NULL,
        sys_man_ind NVARCHAR(25) NULL,
        journal_type NVARCHAR(25) NULL,
        functional_curr_cd NVARCHAR(50) NULL,
        reporting_curr_cd NVARCHAR(50) NULL,
        source_type NVARCHAR(25) NULL,
        net_reporting_amount FLOAT NULL,
        net_reporting_amount_credit FLOAT NULL,
        net_reporting_amount_debit FLOAT NULL,
        net_functional_amount FLOAT NULL,
        net_functional_amount_credit FLOAT NULL,
        net_functional_amount_debit FLOAT NULL,
        --- fixing the prod issue
        period_id INT NULL,
        [ey_account_type] [nvarchar](100) NULL,
        [ey_account_sub_type] [nvarchar](100) NULL,
        [ey_account_class] [nvarchar](100) NULL,
        [ey_account_sub_class] [nvarchar](100) NULL,
        [gl_account_cd] [nvarchar](100) NULL,
        [gl_account_name] [nvarchar](100) NULL,
        [ey_gl_account_name] [nvarchar](200) NULL,
        [ey_account_group_I] [nvarchar](100) NULL,
        [bu_ref] [nvarchar](100) NULL,
        [bu_group] [nvarchar](100) NULL,
        [year_flag_desc] [nvarchar](100) NULL,
        [period_flag_desc] [nvarchar](100) NULL,
        [department] [nvarchar](100) NULL,
        [preparer_ref] [nvarchar](200) NULL,
        [source_ref] [nvarchar](200) NULL,
        [source_group] [nvarchar](200) NULL,
        [segment1_ref] [nvarchar](200) NULL,
        [segment2_ref] [nvarchar](200) NULL,
        [segment1_group] [nvarchar](200) NULL,
        [segment2_group] [nvarchar](200) NULL,
        [sys_manual_ind] [nvarchar](2) NULL,
        [trial_balance_start_date_id] [VARCHAR](25) NULL,
        [trial_balance_end_date_id] [VARCHAR](25) NULL,
        [Beginning_balance] [FLOAT] NULL,
        [Ending_balance] [FLOAT] NULL,
        [functional_beginning_balance] [FLOAT] NULL,
        [functional_ending_balance] [FLOAT] NULL,
        [reporting_beginning_balance] [FLOAT] NULL,
        [reporting_ending_balance] [FLOAT] NULL,
        [Calc_reporting_ending_bal] [FLOAT] NULL,
        [Diff_btw_calc_end_and_report_ending] [FLOAT] NULL,
        [Calc_functional_ending_bal] [FLOAT] NULL,
        [Diff_btw_calc_end_and_func_ending] [FLOAT] NULL,
    )
