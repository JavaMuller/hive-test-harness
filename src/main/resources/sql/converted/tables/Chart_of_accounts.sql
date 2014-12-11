CREATE TABLE Chart_of_accounts (
  coa_id INT,
  bu_id INT,
  engagement_id string,
  coa_effective_date_id INT,
  gl_account_cd VARCHAR(100),
  gl_subacct_cd VARCHAR(100),
  gl_account_name VARCHAR(100),
  gl_subacct_name VARCHAR(100),
  consolidation_account VARCHAR(100),
  ey_account_type VARCHAR(100),
  ey_account_sub_type VARCHAR(100),
  ey_account_class VARCHAR(100),
  ey_account_sub_class VARCHAR(100),
  ey_account_group_I VARCHAR(100),
  ey_account_group_II VARCHAR(100),
  ey_sub_ledger VARCHAR(100),
  ey_account_BS_PL VARCHAR(100),
  ey_cash_activity VARCHAR(100),
  ey_index VARCHAR(100),
  ey_sub_index VARCHAR(100),
  ey_management_account_ind VARCHAR(100),
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;