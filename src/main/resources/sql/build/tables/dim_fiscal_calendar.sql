CREATE TABLE dim_fiscal_calendar (
  period_id INT,
  bu_id INT,
  fiscal_period_cd string,
  fiscal_period_desc string,
  fiscal_period_start string,
  fiscal_period_end string,
  fiscal_quarter_cd string,
  fiscal_quarter_desc string,
  fiscal_quarter_start string,
  fiscal_quarter_end string,
  fiscal_year_cd string,
  fiscal_year_desc string,
  fiscal_year_start string,
  fiscal_year_end string,
  adjustment_period string,
  engagement_id string,
  fiscal_period_seq INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;

CREATE TABLE dim_fiscal_calendar_csv (
  period_id INT,
  bu_id INT,
  fiscal_period_cd string,
  fiscal_period_desc string,
  fiscal_period_start string,
  fiscal_period_end string,
  fiscal_quarter_cd string,
  fiscal_quarter_desc string,
  fiscal_quarter_start string,
  fiscal_quarter_end string,
  fiscal_year_cd string,
  fiscal_year_desc string,
  fiscal_year_start string,
  fiscal_year_end string,
  adjustment_period string,
  engagement_id string,
  fiscal_period_seq INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/dim_fiscal_calendar.csv' into table dim_fiscal_calendar_csv;

insert into table dim_fiscal_calendar  select * from dim_fiscal_calendar_csv;
