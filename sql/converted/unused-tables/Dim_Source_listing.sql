CREATE TABLE Dim_Source_listing (
  Source_Id INT,
  source_cd VARCHAR(25),
  source_desc VARCHAR(100),
  erp_subledger_module VARCHAR(100),
  bus_process_major VARCHAR(100),
  bus_process_minor VARCHAR(100),
  source_ref VARCHAR(200),
  sys_manual_ind CHAR(1),
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100),
  ey_source_group VARCHAR(200)
) stored AS orc;
