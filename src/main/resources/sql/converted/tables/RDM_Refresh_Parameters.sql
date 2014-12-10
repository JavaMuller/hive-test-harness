CREATE TABLE RDM_Refresh_Parameters (
  row_counter INT NOT NULL IDENTITY(1, 1),
  data_refresh_counter INT NOT NULL,
  refresh_stream NVARCHAR (50) NULL,
  startup_point NVARCHAR (100) NULL,
  sp_name NVARCHAR (500) NULL,
  old_data_refresh_counter INT NULL,
  event_date_time DATETIME NULL,
  level INT NULL
)