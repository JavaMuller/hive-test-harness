CREATE TABLE RDM_Refresh_Parameters (
  row_counter INT,
  data_refresh_counter INT,
  refresh_stream VARCHAR(50),
  startup_point VARCHAR(100),
  sp_name VARCHAR(500),
  old_data_refresh_counter INT,
  event_date_time TIMESTAMP,
  level INT
) stored AS orc;