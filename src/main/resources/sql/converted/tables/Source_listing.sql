CREATE TABLE Source_listing (
  source_id INT,
  engagement_id string,
  source_cd string,
  source_desc string,
  ey_source_group string,
  erp_subledger_module string,
  bus_process_major string,
  bus_process_minor string,
  sys_manual_ind string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;