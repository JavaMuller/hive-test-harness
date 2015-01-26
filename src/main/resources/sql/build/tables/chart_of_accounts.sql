CREATE TABLE chart_of_accounts (
  coa_id INT,
  bu_id INT,
  engagement_id string,
  coa_effective_date_id INT,
  gl_account_cd string,
  gl_subacct_cd string,
  gl_account_name string,
  gl_subacct_name string,
  consolidation_account string,
  ey_account_type string,
  ey_account_sub_type string,
  ey_account_class string,
  ey_account_sub_class string,
  ey_account_group_I string,
  ey_account_group_II string,
  ey_sub_ledger string,
  ey_account_BS_PL string,
  ey_cash_activity string,
  ey_index string,
  ey_sub_index string,
  ey_management_account_ind string,
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;

CREATE TABLE chart_of_accounts_csv (
  coa_id INT,
  bu_id INT,
  engagement_id string,
  coa_effective_date_id INT,
  gl_account_cd string,
  gl_subacct_cd string,
  gl_account_name string,
  gl_subacct_name string,
  consolidation_account string,
  ey_account_type string,
  ey_account_sub_type string,
  ey_account_class string,
  ey_account_sub_class string,
  ey_account_group_I string,
  ey_account_group_II string,
  ey_sub_ledger string,
  ey_account_BS_PL string,
  ey_cash_activity string,
  ey_index string,
  ey_sub_index string,
  ey_management_account_ind string,
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/chart_of_accounts.csv' into table chart_of_accounts_csv;

insert into table chart_of_accounts select * from chart_of_accounts_csv;