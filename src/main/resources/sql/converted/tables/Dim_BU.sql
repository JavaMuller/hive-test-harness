CREATE TABLE Dim_BU (
  bu_id INT NOT NULL,
  bu_cd VARCHAR(50) NULL,
  bu_desc VARCHAR(200) NULL,
  bu_ref VARCHAR(250) NULL,
  bu_group VARCHAR(200) NULL,
  ver_start_date_id INT NULL,
  ver_end_date_id INT NULL,
  ver_desc VARCHAR(200) NULL
) stored AS orc;
