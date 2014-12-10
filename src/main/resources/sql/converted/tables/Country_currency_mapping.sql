CREATE TABLE Country_currency_mapping (
  country_cd VARCHAR(10),
  country VARCHAR(200),
  currency_cd VARCHAR(10),
  currency VARCHAR(200)
) stored AS orc;
