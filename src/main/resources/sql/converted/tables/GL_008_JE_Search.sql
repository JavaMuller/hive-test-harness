CREATE TABLE GL_008_JE_Search (
  Journal_entry_id VARCHAR(100) NULL,
  Journal_entry_line VARCHAR(100) NULL,
  Journal_entry_description VARCHAR(250) NULL,
  Journal_entry_type VARCHAR(25) NULL,
  Reporting_amount FLOAT NULL,
  Functional_amount FLOAT NULL,
  Journal_line_description VARCHAR(250) NULL,
  Year_flag VARCHAR(25) NULL,
  Period_flag VARCHAR(25) NULL,
  Bu_id INT NULL,
  Segment1_id INT NULL,
  Segment2_id INT NULL,
  Source_id INT NULL,
  User_listing_id INT NULL,
  Journal_type VARCHAR(25) NULL,
  ey_period VARCHAR(100) NULL
) stored AS orc;
