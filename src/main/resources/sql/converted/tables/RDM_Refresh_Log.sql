CREATE TABLE RDM_Refresh_Log (
  row_counter INT,
  data_refresh_counter INT,
  stream_name VARCHAR(100),
  test_name VARCHAR(200),
  executable_name VARCHAR(200),
  event_status VARCHAR(50),
  event_date_time TIMESTAMP,
  error_msg string
) stored AS orc;
