CREATE TABLE dim_calendar_seq_date (
  Calendar_date TIMESTAMP,
  Sequence INT
) stored AS orc;

CREATE TABLE dim_calendar_seq_date_csv (
  Calendar_date TIMESTAMP,
  Sequence INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/dim_calendar_seq_date.csv' into table dim_calendar_seq_date_csv;

insert into table dim_calendar_seq_date  select * from dim_calendar_seq_date_csv;