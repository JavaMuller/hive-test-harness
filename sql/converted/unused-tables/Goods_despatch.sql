CREATE TABLE Goods_despatch (
  despatch_note_id VARCHAR(100),
  despatch_note_line_id VARCHAR(100),
  bu_id INT,
  engagement_id string,
  customer_master_id INT,
  product_id INT,
  period_id INT,
  sales_order_cd VARCHAR(25),
  sales_order_line_id VARCHAR(25),
  goods_despatch_start_date_id INT,
  goods_despatch_end_date_id INT,
  despatch_date_id INT,
  line_price FLOAT,
  line_price_curr_cd VARCHAR(25),
  line_quantity FLOAT,
  line_unit_desc VARCHAR(100),
  entry_by_id INT,
  entry_date_id INT,
  entry_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  approved_by_id INT,
  approved_by_date_id INT,
  je_id VARCHAR(100),
  je_line_id VARCHAR(100),
  ship_from VARCHAR(25),
  ship_to VARCHAR(25),
  segment01 INT,
  segment02 INT,
  segment03 INT,
  segment04 INT,
  segment05 INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;