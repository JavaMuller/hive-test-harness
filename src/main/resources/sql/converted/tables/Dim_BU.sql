CREATE TABLE if not exists Dim_BU (
  bu_id INT NOT NULL,
  bu_cd varchar (50) NULL,
  bu_desc varchar (200) NULL,
  bu_ref varchar (250) NULL,
  bu_group varchar (200) NULL,
  ver_start_date_id INT NULL,
  ver_end_date_id INT NULL,
  ver_desc varchar (200) NULL
)
