CREATE TABLE AP_activity (
  transaction_cd VARCHAR(50),
  transaction_type_id INT,
  source_id INT,
  bu_id INT,
  engagement_id string,
  vendor_master_id INT,
  invoice_type VARCHAR(25),
  purchase_invoice_cd VARCHAR(100),
  clearing_document_id VARCHAR(100),
  period_id INT,
  transaction_no VARCHAR(100),
  je_id VARCHAR(100),
  je_line_id VARCHAR(100),
  transaction_desc VARCHAR(200),
  activity_start_date_id INT,
  activity_end_date_id INT,
  transaction_date_id INT,
  document_date_id INT,
  coa_id INT,
  dr_cr_ind CHAR(1),
  amount FLOAT,
  purchase_tax FLOAT,
  net_amount FLOAT,
  amount_curr_cd VARCHAR(25),
  document_amount FLOAT,
  document_purchase_tax FLOAT,
  document_net_amount FLOAT,
  document_amount_curr_cd VARCHAR(25),
  reporting_amount FLOAT,
  reporting_purchase_tax FLOAT,
  reporting_net_amount FLOAT,
  reporting_amount_curr_cd VARCHAR(25),
  discount_terms_percentage FLOAT,
  discount_terms_days INT,
  transaction_due_date_id INT,
  external_reference_number VARCHAR(100),
  external_reference_date_id INT,
  entry_by_id INT,
  entry_date_id INT,
  entry_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  approved_by_id INT,
  approved_by_date_id INT,
  closed_date_id INT,
  posting_status VARCHAR(100),
  segment01 INT,
  segment02 INT,
  segment03 INT,
  segment04 INT,
  segment05 INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;