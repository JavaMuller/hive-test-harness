CREATE TABLE trial_balance (
  coa_id INT,
  bu_id INT,
  period_id INT,
  segment1_id INT,
  segment2_id INT,
  engagement_id string,
  trial_balance_start_date_id INT,
  trial_balance_end_date_id INT,
  functional_beginning_balance FLOAT,
  functional_ending_balance FLOAT,
  functional_curr_cd string,
  beginning_balance FLOAT,
  ending_balance FLOAT,
  balance_curr_cd string,
  reporting_beginning_balance FLOAT,
  reporting_ending_balance FLOAT,
  reporting_curr_cd string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;

CREATE TABLE trial_balance_csv (
  coa_id INT,
  bu_id INT,
  period_id INT,
  segment1_id INT,
  segment2_id INT,
  engagement_id string,
  trial_balance_start_date_id INT,
  trial_balance_end_date_id INT,
  functional_beginning_balance FLOAT,
  functional_ending_balance FLOAT,
  functional_curr_cd string,
  beginning_balance FLOAT,
  ending_balance FLOAT,
  balance_curr_cd string,
  reporting_beginning_balance FLOAT,
  reporting_ending_balance FLOAT,
  reporting_curr_cd string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/trial_balance.csv' into table trial_balance_csv;

insert into table trial_balance  select * from trial_balance_csv;

