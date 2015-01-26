CREATE TABLE source_listing (
  source_id INT,
  engagement_id string,
  source_cd string,
  source_desc string,
  ey_source_group string,
  erp_subledger_module string,
  bus_process_major string,
  bus_process_minor string,
  sys_manual_ind string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;

CREATE TABLE source_listing_csv (
  source_id INT,
  engagement_id string,
  source_cd string,
  source_desc string,
  ey_source_group string,
  erp_subledger_module string,
  bus_process_major string,
  bus_process_minor string,
  sys_manual_ind string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/source_listing.csv' into table source_listing_csv;

insert into table source_listing  select * from source_listing_csv;