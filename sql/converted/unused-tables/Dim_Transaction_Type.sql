CREATE TABLE Dim_Transaction_Type (
  transaction_type_id INT,
  transaction_type_cd VARCHAR(25),
  bu_id INT,
  engagement_id string,
  transaction_type_desc VARCHAR(100),
  transaction_type_group_desc VARCHAR(100),
  EY_transaction_type VARCHAR(25),
  entry_by_id INT,
  entry_date_id INT,
  entry_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100),
  transaction_type_ref VARCHAR(125)
) stored AS orc;
