CREATE TABLE Dim_BU (
  bu_id INT,
  bu_cd VARCHAR(50),
  bu_desc VARCHAR(200),
  bu_ref VARCHAR(250),
  bu_group VARCHAR(200),
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(200)
) stored AS orc;
