CREATE TABLE if not exists Parameters_period (
  year_flag VARCHAR (25) NOT NULL,
  year_flag_desc VARCHAR (100) NOT NULL,
  period_flag VARCHAR (25) NOT NULL,
  period_flag_desc VARCHAR (100) NOT NULL,
  fiscal_period_seq_start INT NULL,
  fiscal_period_seq_end INT NULL,
  fiscal_year_cd VARCHAR (100) NULL,
  start_date DATE NULL,
  end_date DATE NULL,
  year_start_date DATE NULL,
  year_end_date DATE NULL
)