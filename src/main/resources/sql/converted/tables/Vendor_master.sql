CREATE TABLE Vendor_master (
  vendor_master_id INT,
  bu_id INT,
  engagement_id string,
  vendor_master_as_of_date_id INT,
  vendor_account_cd VARCHAR(100),
  vendor_account_name VARCHAR(100),
  vendor_group VARCHAR(100),
  vendor_physical_street_addr1 VARCHAR(100),
  vendor_physical_street_addr2 VARCHAR(100),
  vendor_physical_city VARCHAR(100),
  vendor_physical_state_province VARCHAR(100),
  vendor_physical_country VARCHAR(100),
  vendor_physical_zip_code VARCHAR(100),
  vendor_tax_id VARCHAR(100),
  vendor_billing_address1 VARCHAR(100),
  vendor_billing_address2 VARCHAR(100),
  vendor_billing_city VARCHAR(100),
  vendor_billing_state_province VARCHAR(100),
  vendor_billing_country VARCHAR(100),
  vendor_billing_zip_code VARCHAR(100),
  payment_terms_desc VARCHAR(100),
  payment_terms_days INT,
  bank_name VARCHAR(100),
  bank_account_no VARCHAR(100),
  beneficiary VARCHAR(100),
  active_ind CHAR(1),
  active_ind_change_date_id INT,
  credit_limit_curr_cd VARCHAR(25),
  transaction_credit_limit FLOAT,
  overall_credit_limit FLOAT,
  ey_related_party VARCHAR(100),
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  approved_by_id INT,
  approved_by_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;