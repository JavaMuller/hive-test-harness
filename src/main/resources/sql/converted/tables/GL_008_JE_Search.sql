CREATE TABLE GL_008_JE_Search (
  Journal_entry_id nvarchar (100) NULL,
  Journal_entry_line nvarchar (100) NULL,
  Journal_entry_description nvarchar (250) NULL,
  Journal_entry_type nvarchar (25) NULL,
  Reporting_amount FLOAT NULL,
  Functional_amount FLOAT NULL,
  Journal_line_description nvarchar (250) NULL,
  Year_flag nvarchar (25) NULL,
  Period_flag nvarchar (25) NULL,
  Bu_id INT NULL,
  Segment1_id INT NULL,
  Segment2_id INT NULL,
  Source_id INT NULL,
  User_listing_id INT NULL,
  Journal_type nvarchar (25) NULL,
  ey_period nvarchar (100) NULL
)
