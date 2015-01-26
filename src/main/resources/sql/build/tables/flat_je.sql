CREATE TABLE flat_je (
  ID BIGINT,
  je_id string,
  je_line_id string,
  je_line_desc string,
  je_header_desc string,
  dr_cr_ind string,
  coa_id INT,
  period_id INT,
  bu_id INT,
  source_id INT,
  segment1_id INT,
  segment2_id INT,
  segment3_id INT,
  segment4_id INT,
  segment5_id INT,
  ey_je_id string,
  activity string,
  approved_by_id INT,
  transaction_type_id INT,
  reversal_ind string,
  sys_manual_ind string,
  year_flag string,
  period_flag string,
  year_flag_desc string,
  period_flag_desc string,
  year_end_date DATE,
  period_end_date DATE,
  gl_account_cd string,
  gl_subacct_cd string,
  gl_account_name string,
  gl_subacct_name string,
  ey_gl_account_name string,
  consolidation_account string,
  ey_account_type string,
  ey_account_sub_type string,
  ey_account_class string,
  ey_cash_activity string,
  ey_account_sub_class string,
  ey_index string,
  ey_sub_index string,
  ey_account_group_I string,
  ey_account_group_II string,
  sys_manual_ind_src string,
  sys_manual_ind_usr string,
  user_listing_id INT,
  client_user_id string,
  preparer_ref string,
  first_name string,
  last_name string,
  full_name string,
  department string,
  role_resp string,
  title string,
  active_ind string,
  transaction_type_group_desc string,
  transaction_type string,
  fiscal_period_cd string,
  fiscal_period_desc string,
  fiscal_period_start string,
  fiscal_period_end string,
  fiscal_quarter_start string,
  fiscal_quarter_end string,
  fiscal_year_start string,
  fiscal_year_end string,
  EY_fiscal_year string,
  EY_quarter string,
  EY_period string,
  Entry_Date TIMESTAMP,
  Day_of_week string,
  Effective_Date TIMESTAMP,
  Lag_Date INT,
  exchange_rate FLOAT,
  local_exchange_rate FLOAT,
  reporting_exchange_rate FLOAT,
  effective_date_id INT,
  entry_date_id INT,
  functional_curr_cd string,
  functional_amount FLOAT,
  functional_debit_amount FLOAT,
  functional_credit_amount FLOAT,
  amount FLOAT,
  amount_debit FLOAT,
  amount_credit FLOAT,
  amount_curr_cd string,
  reporting_amount FLOAT,
  reporting_amount_curr_cd string,
  reporting_amount_debit FLOAT,
  reporting_amount_credit FLOAT,
  engagement_id string,
  entry_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  approved_by_date_id INT,
  reversal_je_id string,
  GL_clearing_document string,
  GL_clearing_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string,
  day_number_of_week INT,
  day_number_of_month INT,
  journal_type string,
  system_load_date TIMESTAMP,
  approver_department string,
  approver_ref string,
  reporting_impact_to_assets FLOAT,
  reporting_impact_to_equity FLOAT,
  reporting_impact_to_expenses FLOAT,
  reporting_impact_to_liabilities FLOAT,
  reporting_impact_to_revenue FLOAT,
  functional_impact_to_assets FLOAT,
  functional_impact_to_equity FLOAT,
  functional_impact_to_expenses FLOAT,
  functional_impact_to_liabilities FLOAT,
  functional_impact_to_revenue FLOAT,
  ey_subledger_type string,
  ey_AR_type string,
  ey_AP_type string,
  ey_reconciliation_GL_group string,
  Adjusted_fiscal_period string
) stored AS orc;

CREATE TABLE flat_je_csv (
  ID BIGINT,
  je_id string,
  je_line_id string,
  je_line_desc string,
  je_header_desc string,
  dr_cr_ind string,
  coa_id INT,
  period_id INT,
  bu_id INT,
  source_id INT,
  segment1_id INT,
  segment2_id INT,
  segment3_id INT,
  segment4_id INT,
  segment5_id INT,
  ey_je_id string,
  activity string,
  approved_by_id INT,
  transaction_type_id INT,
  reversal_ind string,
  sys_manual_ind string,
  year_flag string,
  period_flag string,
  year_flag_desc string,
  period_flag_desc string,
  year_end_date DATE,
  period_end_date DATE,
  gl_account_cd string,
  gl_subacct_cd string,
  gl_account_name string,
  gl_subacct_name string,
  ey_gl_account_name string,
  consolidation_account string,
  ey_account_type string,
  ey_account_sub_type string,
  ey_account_class string,
  ey_cash_activity string,
  ey_account_sub_class string,
  ey_index string,
  ey_sub_index string,
  ey_account_group_I string,
  ey_account_group_II string,
  sys_manual_ind_src string,
  sys_manual_ind_usr string,
  user_listing_id INT,
  client_user_id string,
  preparer_ref string,
  first_name string,
  last_name string,
  full_name string,
  department string,
  role_resp string,
  title string,
  active_ind string,
  transaction_type_group_desc string,
  transaction_type string,
  fiscal_period_cd string,
  fiscal_period_desc string,
  fiscal_period_start string,
  fiscal_period_end string,
  fiscal_quarter_start string,
  fiscal_quarter_end string,
  fiscal_year_start string,
  fiscal_year_end string,
  EY_fiscal_year string,
  EY_quarter string,
  EY_period string,
  Entry_Date TIMESTAMP,
  Day_of_week string,
  Effective_Date TIMESTAMP,
  Lag_Date INT,
  exchange_rate FLOAT,
  local_exchange_rate FLOAT,
  reporting_exchange_rate FLOAT,
  effective_date_id INT,
  entry_date_id INT,
  functional_curr_cd string,
  functional_amount FLOAT,
  functional_debit_amount FLOAT,
  functional_credit_amount FLOAT,
  amount FLOAT,
  amount_debit FLOAT,
  amount_credit FLOAT,
  amount_curr_cd string,
  reporting_amount FLOAT,
  reporting_amount_curr_cd string,
  reporting_amount_debit FLOAT,
  reporting_amount_credit FLOAT,
  engagement_id string,
  entry_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  approved_by_date_id INT,
  reversal_je_id string,
  GL_clearing_document string,
  GL_clearing_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string,
  day_number_of_week INT,
  day_number_of_month INT,
  journal_type string,
  system_load_date TIMESTAMP,
  approver_department string,
  approver_ref string,
  reporting_impact_to_assets FLOAT,
  reporting_impact_to_equity FLOAT,
  reporting_impact_to_expenses FLOAT,
  reporting_impact_to_liabilities FLOAT,
  reporting_impact_to_revenue FLOAT,
  functional_impact_to_assets FLOAT,
  functional_impact_to_equity FLOAT,
  functional_impact_to_expenses FLOAT,
  functional_impact_to_liabilities FLOAT,
  functional_impact_to_revenue FLOAT,
  ey_subledger_type string,
  ey_AR_type string,
  ey_AP_type string,
  ey_reconciliation_GL_group string,
  Adjusted_fiscal_period string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/flat_je.1.csv' into table flat_je_csv;
load data inpath '/poc/data/ey/flat_je.2.csv' into table flat_je_csv;
load data inpath '/poc/data/ey/flat_je.3.csv' into table flat_je_csv;

insert into table flat_je  select * from flat_je_csv;
