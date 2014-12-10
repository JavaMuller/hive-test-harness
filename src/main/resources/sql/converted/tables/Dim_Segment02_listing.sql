CREATE TABLE Dim_Segment02_listing (
  segment_id INT NOT NULL,
  engagement_id uniqueidentifier NULL,
  segment_cd VARCHAR(25) NULL,
  segment_desc VARCHAR(100) NULL,
  segment_ref VARCHAR(125) NULL,
  ey_segment_group VARCHAR(100) NULL,
  ver_start_date_id INT NOT NULL,
  ver_end_date_id INT NULL,
  ver_desc VARCHAR(100) NULL
) stored AS orc;
