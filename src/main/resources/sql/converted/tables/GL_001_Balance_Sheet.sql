CREATE TABLE GL_001_Balance_Sheet (
  COA_Id INT NULL,
  Period_Id INT NULL,
  Bu_id INT NULL,
  Segment_1_id INT NULL,
  Segment_2_id INT NULL,
  Source_id INT NULL,
  user_listing_id INT NULL,
  approved_by_id INT NULL,
  Year_flag nvarchar (50) NULL,
  Period_flag nvarchar (50) NULL,
  Accounting_period nvarchar (100) NULL,
  Accounting_sub_period nvarchar (100) NULL,
  YEAR nvarchar (100) NULL,
  Fiscal_period nvarchar (100) NULL,
  Journal_type nvarchar (25) NULL,
  Functional_Currency_Code nvarchar (50) NULL,
  Reporting_currency_code nvarchar (50) NULL,
  Net_reporting_amount FLOAT NULL,
  Net_reporting_amount_credit FLOAT NULL,
  Net_reporting_amount_debit FLOAT NULL,
  Net_reporting_amount_current FLOAT NULL,
  Net_reporting_amount_credit_current FLOAT NULL,
  Net_reporting_amount_debit_current FLOAT NULL,
  Net_reporting_amount_interim FLOAT NULL,
  Net_reporting_amount_credit_interim FLOAT NULL,
  Net_reporting_amount_debit_interim FLOAT NULL,
  Net_reporting_amount_prior FLOAT NULL,
  Net_reporting_amount_credit_prior FLOAT NULL,
  Net_reporting_amount_debit_prior FLOAT NULL,
  Net_functional_amount FLOAT NULL,
  Net_functional_amount_credit FLOAT NULL,
  Net_functional_amount_debit FLOAT NULL,
  Net_functional_amount_current FLOAT NULL,
  Net_functional_amount_credit_current FLOAT NULL,
  Net_functional_amount_debit_current FLOAT NULL,
  Net_functional_amount_interim FLOAT NULL,
  Net_functional_amount_credit_interim FLOAT NULL,
  Net_functional_amount_debit_interim FLOAT NULL,
  Net_functional_amount_prior FLOAT NULL,
  Net_functional_amount_credit_prior FLOAT NULL,
  Net_functional_amount_debit_prior FLOAT NULL,
  Source_type VARCHAR(17) NULL,
  Period_end_date DATE NULL,
  Fiscal_period_sequence INT NULL,
  Fiscal_period_sequence_end INT NULL
)
