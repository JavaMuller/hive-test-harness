CREATE TABLE currency (
  curr_cd string,
  curr_desc string,
  currency_zone string
) stored AS orc;

CREATE TABLE currency_csv (
  curr_cd string,
  curr_desc string,
  currency_zone string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/currency.csv' into table currency_csv;

insert into table currency select * from currency_csv;