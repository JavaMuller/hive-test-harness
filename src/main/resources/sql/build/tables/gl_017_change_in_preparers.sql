CREATE TABLE gl_017_change_in_preparers (
  bu_id INT,
  source_id INT,
  segment1_id INT,
  segment2_id INT,
  year_flag_desc string,
  period_flag_desc string,
  year_flag string,
  period_flag string,
  bu_group string,
  bu_ref string,
  segment1_ref string,
  segment2_ref string,
  segment1_group string,
  segment2_group string,
  Ey_period string,
  source_group string,
  Source_ref string,
  sys_manual_ind string,
  Journal_type string,
  preparer_ref string,
  department string,
  Category string,
  reporting_amount_curr_cd string,
  functional_curr_cd string
) stored AS orc;

CREATE TABLE gl_017_change_in_preparers_csv (
  bu_id INT,
  source_id INT,
  segment1_id INT,
  segment2_id INT,
  year_flag_desc string,
  period_flag_desc string,
  year_flag string,
  period_flag string,
  bu_group string,
  bu_ref string,
  segment1_ref string,
  segment2_ref string,
  segment1_group string,
  segment2_group string,
  Ey_period string,
  source_group string,
  Source_ref string,
  sys_manual_ind string,
  Journal_type string,
  preparer_ref string,
  department string,
  Category string,
  reporting_amount_curr_cd string,
  functional_curr_cd string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/gl_017_change_in_preparers.csv' into table gl_017_change_in_preparers_csv;

insert into table gl_017_change_in_preparers  select * from gl_017_change_in_preparers_csv;