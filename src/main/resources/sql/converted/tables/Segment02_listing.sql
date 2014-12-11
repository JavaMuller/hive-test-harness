CREATE TABLE Segment02_listing (
  segment_id INT,
  engagement_id string,
  segment_cd VARCHAR(25),
  segment_desc VARCHAR(100),
  ey_segment_group VARCHAR(100),
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;