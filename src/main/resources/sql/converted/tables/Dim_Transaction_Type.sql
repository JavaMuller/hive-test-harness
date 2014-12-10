CREATE TABLE Dim_Transaction_Type (
  transaction_type_id INT NOT NULL,
  transaction_type_cd VARCHAR(25) NOT NULL,
  bu_id INT NOT NULL,
  engagement_id uniqueidentifier NOT NULL,
  transaction_type_desc VARCHAR(100) NULL,
  transaction_type_group_desc VARCHAR(100) NULL,
  EY_transaction_type VARCHAR(25) NULL,
  entry_by_id INT NULL,
  entry_date_id INT NOT NULL,
  entry_time_id INT NOT NULL,
  last_modified_by_id INT NOT NULL,
  last_modified_date_id INT NOT NULL,
  ver_start_date_id INT NOT NULL,
  ver_end_date_id INT NULL,
  ver_desc VARCHAR(100) NULL,
  transaction_type_ref VARCHAR(125) NULL
) stored AS orc;
