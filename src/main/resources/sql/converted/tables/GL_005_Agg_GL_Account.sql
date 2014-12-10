CREATE TABLE GL_005_Agg_GL_Account (
  coa_id INT,
  account_type VARCHAR(100),
  account_sub_type VARCHAR(100),
  account_class VARCHAR(100),
  account_sub_class VARCHAR(100),
  gl_account_cd VARCHAR(100),
  gl_account_name VARCHAR(100),
  ey_gl_account_name VARCHAR(200),
  period_id INT,
  year_flag VARCHAR(4),
  period_flag VARCHAR(4),
  ey_period VARCHAR(50),
  year_flag_desc VARCHAR(200),
  period_flag_desc VARCHAR(200),
  bu_id INT,
  source_id INT,
  segment1_id INT,
  user_listing_id INT,
  preparer_ref VARCHAR(200),
  Preparer_department VARCHAR(100),
  approved_by_id INT,
  Approver_Ref VARCHAR(104),
  Approver_department VARCHAR(100),
  dr_cr_ind CHAR(1),
  reversal_ind CHAR(1),
  Sys_man_ind CHAR(1),
  entry_date_id INT,
  effective_date_id INT,
  amount_curr_cd VARCHAR(50),
  reporting_amount_curr_cd VARCHAR(50),
  functional_curr_cd VARCHAR(50),
  Net_amount FLOAT,
  Net_amount_credit FLOAT,
  Net_amount_debit FLOAT,
  Net_reporting_amount FLOAT,
  Net_reporting_amount_debit FLOAT,
  Net_reporting_amount_credit FLOAT,
  functional_amount FLOAT,
  functional_debit_amount FLOAT,
  functional_credit_amount FLOAT,
  journal_type VARCHAR(25)
) stored AS orc;
