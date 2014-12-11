CREATE TABLE AP_matching (
  receipt_note_id VARCHAR(100),
  receipt_note_line_id VARCHAR(100),
  purchase_invoice_cd VARCHAR(100),
  purchase_invoice_line_cd VARCHAR(100),
  bu_id INT,
  engagement_id string,
  ap_matching_start_date_id INT,
  ap_matching_end_date_id INT,
  applied_amount FLOAT,
  applied_document_amount FLOAT,
  applied_quantity FLOAT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;