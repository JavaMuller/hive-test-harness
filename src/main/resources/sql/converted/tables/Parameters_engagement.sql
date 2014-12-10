CREATE TABLE Parameters_engagement (
  engagement_id string,
  planning_materiality VARCHAR(50),
  tolerable_error INT,
  sad_thresholds INT,
  current_year_cd VARCHAR(100),
  audit_period_end_period_cd VARCHAR(100),
  interim_period_end_period_cd VARCHAR(100),
  prior_year_cd VARCHAR(100),
  comparative_period_end_period_cd VARCHAR(100),
  receivables_ey_class VARCHAR(100),
  AR_aged_debt_threshold INT,
  AR_aging_basis VARCHAR(50),
  AP_aging_basis VARCHAR(50),
  bu_id_for_dates INT,
  Segment_selection1 VARCHAR(50),
  Segment_selection2 VARCHAR(50),
  prior_period_start_date DATE,
  prior_period_end_date DATE,
  comparative_period_end_date DATE,
  audit_period_start_date DATE,
  audit_period_end_date DATE,
  interim_period_end_date DATE,
  system_manual_indicator_option VARCHAR(50)
) stored AS orc;