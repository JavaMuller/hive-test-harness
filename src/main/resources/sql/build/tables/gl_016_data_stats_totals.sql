CREATE TABLE gl_016_data_stats_totals (
  Metric_T string,
  Metric_Count_T INT,
  Period_Type_T string
) stored AS orc;

CREATE TABLE gl_016_data_stats_totals_csv (
  Metric_T string,
  Metric_Count_T INT,
  Period_Type_T string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/gl_016_data_stats_totals.csv' into table gl_016_data_stats_totals_csv;

insert into table gl_016_data_stats_totals  select * from gl_016_data_stats_totals_csv;
