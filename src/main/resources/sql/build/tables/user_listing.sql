CREATE TABLE user_listing (
  user_listing_id INT,
  bu_id INT,
  engagement_id string,
  client_user_id string,
  first_name string,
  last_name string,
  full_name string,
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
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;

CREATE TABLE user_listing_csv (
  user_listing_id INT,
  bu_id INT,
  engagement_id string,
  client_user_id string,
  first_name string,
  last_name string,
  full_name string,
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
  ver_end_date_id INT,
  ver_desc string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/user_listing.csv' into table user_listing_csv;

insert into table user_listing  select * from user_listing_csv;