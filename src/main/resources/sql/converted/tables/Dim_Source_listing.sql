CREATE TABLE Dim_Source_listing (
  Source_Id INT NOT NULL,
  source_cd VARCHAR(25) NULL,
  source_desc VARCHAR(100) NULL,
  erp_subledger_module VARCHAR(100) NULL,
  bus_process_major VARCHAR(100) NULL,
  bus_process_minor VARCHAR(100) NULL,
  source_ref VARCHAR(200) NULL,
  sys_manual_ind CHAR(1) NULL,
  ver_start_date_id INT NULL,
  ver_end_date_id INT NULL,
  ver_desc VARCHAR(100) NULL,
  ey_source_group VARCHAR(200) NULL
) stored AS orc;
