CREATE TABLE Source_listing (
  source_id INT,
  engagement_id string,
  source_cd VARCHAR(25),
  source_desc VARCHAR(100),
  ey_source_group VARCHAR(100),
  erp_subledger_module VARCHAR(100),
  bus_process_major VARCHAR(100),
  bus_process_minor VARCHAR(100),
  sys_manual_ind CHAR(1),
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;