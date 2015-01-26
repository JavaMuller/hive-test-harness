CREATE TABLE parameters_period (
  year_flag string,
  year_flag_desc string,
  period_flag string,
  period_flag_desc string,
  fiscal_period_seq_start INT,
  fiscal_period_seq_end INT,
  fiscal_year_cd string,
  start_date DATE,
  end_date DATE,
  year_start_date DATE,
  year_end_date DATE
) stored AS orc;

CREATE TABLE parameters_period_csv (
  year_flag string,
  year_flag_desc string,
  period_flag string,
  period_flag_desc string,
  fiscal_period_seq_start INT,
  fiscal_period_seq_end INT,
  fiscal_year_cd string,
  start_date DATE,
  end_date DATE,
  year_start_date DATE,
  year_end_date DATE
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/parameters_period.csv' into table parameters_period_csv;

insert into table parameters_period  select * from parameters_period_csv;