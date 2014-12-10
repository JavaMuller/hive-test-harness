CREATE TABLE if not exists Dim_Segment02_listing (
  segment_id INT NOT NULL,
  engagement_id uniqueidentifier NULL,
  segment_cd varchar (25) NULL,
  segment_desc varchar (100) NULL,
  segment_ref varchar (125) NULL,
  ey_segment_group varchar (100) NULL,
  ver_start_date_id INT NOT NULL,
  ver_end_date_id INT NULL,
  ver_desc varchar (100) NULL
)
