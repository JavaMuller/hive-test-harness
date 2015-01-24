CREATE TABLE RDM_Refresh_Executables (
  row_counter INT,
  Sequence INT,
  sp_name VARCHAR(500),
  sp_id INT,
  refresh_stream VARCHAR(50),
  level INT
) stored AS orc;