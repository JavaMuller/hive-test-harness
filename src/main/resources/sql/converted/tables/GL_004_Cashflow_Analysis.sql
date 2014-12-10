CREATE TABLE
    GL_004_Cashflow_Analysis
    (
        coa_id INT NULL,
        bu_id INT NULL,
        source_id INT NULL,
        segment1_id INT NULL,
        segment2_id INT NULL,
        user_listing_id INT NULL,
        approved_by_id INT NULL,
        year_flag NVARCHAR(3) NULL,
        period_flag NVARCHAR(3) NULL,
        ey_period NVARCHAR(16) NULL,
        sys_man_ind NVARCHAR(25) NULL,
        journal_type NVARCHAR(25) NULL,
        functional_curr_cd NVARCHAR(25) NULL,
        reporting_curr_cd NVARCHAR(25) NULL,
        source_type NVARCHAR(25) NULL,
        net_reporting_amount FLOAT NULL,
        net_reporting_amount_credit FLOAT NULL,
        net_reporting_amount_debit FLOAT NULL,
        net_functional_amount FLOAT NULL,
        net_functional_amount_credit FLOAT NULL,
        net_functional_amount_debit FLOAT NULL
    )
