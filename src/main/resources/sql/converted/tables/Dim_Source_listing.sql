CREATE TABLE if not exists Dim_Source_listing (
  Source_Id INT NOT NULL,
  source_cd varchar (25) NULL,
  source_desc varchar (100) NULL,
  erp_subledger_module varchar (100) NULL,
  bus_process_major varchar (100) NULL,
  bus_process_minor varchar (100) NULL,
  source_ref varchar (200) NULL,
  sys_manual_ind CHAR(1) NULL,
  ver_start_date_id INT NULL,
  ver_end_date_id INT NULL,
  ver_desc varchar (100) NULL,
  ey_source_group varchar (200) NULL
)
