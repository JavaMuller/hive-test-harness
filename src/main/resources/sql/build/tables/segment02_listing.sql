CREATE TABLE segment02_listing (
  segment_id INT,
  engagement_id string,
  segment_cd string,
  segment_desc string,
  ey_segment_group string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;

CREATE TABLE segment02_listing_csv (
  segment_id INT,
  engagement_id string,
  segment_cd string,
  segment_desc string,
  ey_segment_group string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/segment02_listing.csv' into table segment02_listing_csv;

insert into table segment02_listing  select * from segment02_listing_csv;