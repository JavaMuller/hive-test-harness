CREATE TABLE Sales_order (
  sales_order_cd VARCHAR(25),
  sales_order_line_id VARCHAR(25),
  bu_id INT,
  engagement_id string,
  customer_master_id INT,
  period_id INT,
  product_id INT,
  sales_order_start_date_id INT,
  sales_order_end_date_id INT,
  sales_order_date_id INT,
  line_amount FLOAT,
  line_quantity FLOAT,
  line_price FLOAT,
  line_amount_curr_cd VARCHAR(25),
  line_unit_desc VARCHAR(100),
  expected_despatch_date_id INT,
  entry_by_id INT,
  entry_date_id INT,
  entry_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  approved_by_id INT,
  approved_by_date_id INT,
  segment01 INT,
  segment02 INT,
  segment03 INT,
  segment04 INT,
  segment05 INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;