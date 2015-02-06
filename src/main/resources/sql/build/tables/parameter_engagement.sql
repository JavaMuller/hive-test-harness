CREATE TABLE Parameters_engagement (
  engagement_id string,
  planning_materiality string,
  tolerable_error INT,
  sad_thresholds INT,
  current_year_cd string,
  audit_period_end_period_cd string,
  interim_period_end_period_cd string,
  prior_year_cd string,
  comparative_period_end_period_cd string,
  receivables_ey_class string,
  AR_aged_debt_threshold INT,
  AR_aging_basis string,
  AP_aging_basis string,
  bu_id_for_dates INT,
  Segment_selection1 string,
  Segment_selection2 string,
  prior_period_start_date DATE,
  prior_period_end_date DATE,
  comparative_period_end_date DATE,
  audit_period_start_date DATE,
  audit_period_end_date DATE,
  interim_period_end_date DATE,
  system_manual_indicator_option string
) stored AS orc;


CREATE TABLE Parameters_engagement_csv (
  engagement_id string,
  planning_materiality string,
  tolerable_error INT,
  sad_thresholds INT,
  current_year_cd string,
  audit_period_end_period_cd string,
  interim_period_end_period_cd string,
  prior_year_cd string,
  comparative_period_end_period_cd string,
  receivables_ey_class string,
  AR_aged_debt_threshold INT,
  AR_aging_basis string,
  AP_aging_basis string,
  bu_id_for_dates INT,
  Segment_selection1 string,
  Segment_selection2 string,
  prior_period_start_date DATE,
  prior_period_end_date DATE,
  comparative_period_end_date DATE,
  audit_period_start_date DATE,
  audit_period_end_date DATE,
  interim_period_end_date DATE,
  system_manual_indicator_option string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/parameters_engagement.csv' into table parameters_engagement_csv;

insert into table parameters_engagement  select * from Parameters_engagement_csv;