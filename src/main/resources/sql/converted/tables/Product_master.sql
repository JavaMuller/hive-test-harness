CREATE TABLE Product_master (
  product_master_id INT,
  bu_id INT,
  engagement_id string,
  client_product_cd VARCHAR(25),
  product_desc VARCHAR(100),
  product_group VARCHAR(25),
  product_type VARCHAR(25),
  sales_unit VARCHAR(25),
  purchase_unit VARCHAR(25),
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;