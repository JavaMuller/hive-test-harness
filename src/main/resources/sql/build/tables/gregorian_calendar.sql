CREATE TABLE gregorian_calendar (
  date_id INT,
  calendar_date TIMESTAMP,
  month_id INT,
  month_desc string,
  quarter_id INT,
  quarter_desc string,
  year_id INT,
  day_number_of_week INT,
  day_of_week_desc string,
  day_number_of_month INT,
  day_number_of_year INT,
  week_number_of_year INT
) stored AS orc;

CREATE TABLE gregorian_calendar_csv (
  date_id INT,
  calendar_date TIMESTAMP,
  month_id INT,
  month_desc string,
  quarter_id INT,
  quarter_desc string,
  year_id INT,
  day_number_of_week INT,
  day_of_week_desc string,
  day_number_of_month INT,
  day_number_of_year INT,
  week_number_of_year INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/gregorian_calendar.csv' into table gregorian_calendar_csv;

insert into table gregorian_calendar  select * from gregorian_calendar_csv;