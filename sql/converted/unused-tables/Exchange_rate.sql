CREATE TABLE Exchange_rate (
  date_id INT,
  curr_cd VARCHAR(25),
  exchange_rate FLOAT,
  exchange_rate_buy FLOAT,
  exchange_rate_sell FLOAT,
  import_date_id INT,
  import_origin VARCHAR(100)
) stored AS orc;