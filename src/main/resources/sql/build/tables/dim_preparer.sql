CREATE TABLE dim_preparer (
  user_listing_id INT,
  client_user_id string,
  first_name string,
  last_name string,
  full_name string,
  preparer_ref string,
  department string,
  title string,
  role_resp string,
  sys_manual_ind string,
  active_ind string,
  active_ind_change_date_id INT,
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT
) stored AS orc;

CREATE TABLE dim_preparer_csv (
  user_listing_id INT,
  client_user_id string,
  first_name string,
  last_name string,
  full_name string,
  preparer_ref string,
  department string,
  title string,
  role_resp string,
  sys_manual_ind string,
  active_ind string,
  active_ind_change_date_id INT,
  created_by_id INT,
  created_date_id INT,
  created_time_id INT,
  last_modified_by_id INT,
  last_modified_date_id INT,
  ver_start_date_id INT,
  ver_end_date_id INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/dim_preparer.csv' into table dim_preparer_csv;

insert into table dim_preparer  select * from dim_preparer_csv;