CREATE TABLE if not exists RDM_Refresh_Log (
  row_counter INT NOT NULL IDENTITY(1, 1),
  data_refresh_counter INT NOT NULL,
  stream_name VARCHAR (100) NULL,
  test_name VARCHAR (200) NULL,
  executable_name VARCHAR (200) NULL,
  event_status VARCHAR (50) NULL,
  event_date_time DATETIME NULL,
  error_msg VARCHAR (MAX) NULL
)