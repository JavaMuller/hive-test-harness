CREATE TABLE Currency_xref (
  curr_cd VARCHAR(25),
  client_curr_cd VARCHAR(25),
  client_curr_desc VARCHAR(100),
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;