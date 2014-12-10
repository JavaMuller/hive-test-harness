CREATE TABLE Parameters_period (
  year_flag VARCHAR(25),
  year_flag_desc VARCHAR(100),
  period_flag VARCHAR(25),
  period_flag_desc VARCHAR(100),
  fiscal_period_seq_start INT,
  fiscal_period_seq_end INT,
  fiscal_year_cd VARCHAR(100),
  start_date DATE,
  end_date DATE,
  year_start_date DATE,
  year_end_date DATE
) stored AS orc;