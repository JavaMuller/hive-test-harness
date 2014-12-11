CREATE TABLE Sales_invoice_header (
  sales_invoice_cd VARCHAR(100),
  bu_id INT,
  engagement_id string,
  customer_master_id INT,
  effective_date_id INT,
  document_date_id INT,
  segment01 INT,
  segment02 INT,
  segment03 INT,
  segment04 INT,
  segment05 INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;