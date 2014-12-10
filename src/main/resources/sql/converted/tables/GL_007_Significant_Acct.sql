CREATE TABLE
    [GL_007_Significant_Acct]
    (
        coa_id INT NULL ,
        bu_id INT NULL ,
        source_id INT NULL ,
        segment1_id INT NULL ,
        segment2_id INT NULL ,
        user_listing_id INT NULL ,
        approved_by_id INT NULL ,
        year_flag NVARCHAR(25) NULL ,
        period_flag NVARCHAR(25) NULL ,
        EY_period NVARCHAR(50) NULL ,
        journal_type NVARCHAR(25) NULL ,
        reporting_curr_cd NVARCHAR(25) NULL ,
        functional_curr_cd NVARCHAR(25) NULL ,
        source_type NVARCHAR(25) NULL ,
        current_amount FLOAT NULL ,
        prior_amount FLOAT NULL ,
        count_of_je_line_items INT NULL ,
        count_of_manual_je_lines INT NULL ,
        manual_amount FLOAT NULL ,
        manual_functional_amount FLOAT NULL ,
        count_ofdistinct_preparers INT NULL ,
        total_debit_activity FLOAT NULL ,
        largest_line_item FLOAT NULL ,
        largest_functional_line_item FLOAT NULL ,
        total_credit_activity FLOAT NULL ,
        net_reporting_amount FLOAT NULL ,
        net_reporting_amount_credit FLOAT NULL ,
        net_reporting_amount_debit FLOAT NULL ,
        net_functional_amount FLOAT NULL ,
        net_functional_amount_credit FLOAT NULL ,
        net_functional_amount_debit FLOAT NULL ,
        functional_ending_balance FLOAT NULL ,
        reporting_ending_balance FLOAT NULL ,
        net_functional_amount_current FLOAT NULL ,
        net_functional_amount_prior FLOAT NULL ,
        net_reporting_amount_current FLOAT NULL ,
        net_reporting_amount_prior FLOAT NULL
    )
