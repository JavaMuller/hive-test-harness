CREATE TABLE gl_016_data_stats_blanks (
  Metric_B string,
  Metric_Count_B INT,
  Period_Type_B string,
  Period_Flag string,
  Column_Name string,
  Start_Date string,
  End_Date string
) stored AS orc;

CREATE TABLE gl_016_data_stats_blanks_csv (
  Metric_B string,
  Metric_Count_B INT,
  Period_Type_B string,
  Period_Flag string,
  Column_Name string,
  Start_Date string,
  End_Date string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/gl_016_data_stats_blanks.csv' into table gl_016_data_stats_blanks_csv;

insert into table gl_016_data_stats_blanks  select * from gl_016_data_stats_blanks_csv;

