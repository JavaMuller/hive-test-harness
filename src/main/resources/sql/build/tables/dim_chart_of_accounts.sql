CREATE TABLE dim_chart_of_accounts (
  Coa_id INT,
  bu_id INT,
  coa_effective_date_id INT,
  gl_account_cd string,
  gl_subacct_cd string,
  gl_account_name string,
  gl_subacct_name string,
  consolidation_account string,
  ey_gl_account_name string,
  ey_account_type string,
  ey_account_sub_type string,
  ey_account_class string,
  ey_account_sub_class string,
  ey_account_group_I string,
  ey_account_group_II string,
  ey_cash_activity string,
  ey_index string,
  ey_sub_index string,
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_desc string,
  ver_start_date_id INT,
  ver_end_date_id INT
) stored AS orc;

CREATE TABLE dim_chart_of_accounts_csv (
  Coa_id INT,
  bu_id INT,
  coa_effective_date_id INT,
  gl_account_cd string,
  gl_subacct_cd string,
  gl_account_name string,
  gl_subacct_name string,
  consolidation_account string,
  ey_gl_account_name string,
  ey_account_type string,
  ey_account_sub_type string,
  ey_account_class string,
  ey_account_sub_class string,
  ey_account_group_I string,
  ey_account_group_II string,
  ey_cash_activity string,
  ey_index string,
  ey_sub_index string,
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_desc string,
  ver_start_date_id INT,
  ver_end_date_id INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/dim_chart_of_accounts.csv' into table dim_chart_of_accounts_csv;

insert into table dim_chart_of_accounts  select * from dim_chart_of_accounts_csv;

