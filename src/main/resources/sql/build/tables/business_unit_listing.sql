create TABLE business_unit_listing (
  bu_id INT,
  engagement_id string,
  bu_cd string,
  bu_desc string,
  bu_hier_01_cd string,
  bu_hier_01_desc string,
  bu_hier_02_cd string,
  bu_hier_02_desc string,
  bu_hier_03_cd string,
  bu_hier_03_desc string,
  bu_hier_04_cd string,
  bu_hier_04_desc string,
  bu_hier_05_cd string,
  bu_hier_05_desc string,
  seg_01_cd string,
  seg_01_desc string,
  seg_02_cd string,
  seg_02_desc string,
  seg_03_cd string,
  seg_03_desc string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) stored AS orc;

create TABLE business_unit_listing_csv (
  bu_id INT,
  engagement_id string,
  bu_cd string,
  bu_desc string,
  bu_hier_01_cd string,
  bu_hier_01_desc string,
  bu_hier_02_cd string,
  bu_hier_02_desc string,
  bu_hier_03_cd string,
  bu_hier_03_desc string,
  bu_hier_04_cd string,
  bu_hier_04_desc string,
  bu_hier_05_cd string,
  bu_hier_05_desc string,
  seg_01_cd string,
  seg_01_desc string,
  seg_02_cd string,
  seg_02_desc string,
  seg_03_cd string,
  seg_03_desc string,
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc string
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054' stored AS textfile;

load data inpath '/poc/data/ey/business_unit_listing.csv' into table business_unit_listing_csv;

insert into table business_unit_listing select * from business_unit_listing_csv;