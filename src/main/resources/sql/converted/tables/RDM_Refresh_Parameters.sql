CREATE TABLE if not exists RDM_Refresh_Parameters (
  row_counter INT NOT NULL IDENTITY(1, 1),
  data_refresh_counter INT NOT NULL,
  refresh_stream VARCHAR (50) NULL,
  startup_point VARCHAR (100) NULL,
  sp_name VARCHAR (500) NULL,
  old_data_refresh_counter INT NULL,
  event_date_time DATETIME NULL,
  level INT NULL
)