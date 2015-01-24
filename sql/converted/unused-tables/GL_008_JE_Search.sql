CREATE TABLE GL_008_JE_Search (
  Journal_entry_id VARCHAR(100),
  Journal_entry_line VARCHAR(100),
  Journal_entry_description VARCHAR(250),
  Journal_entry_type VARCHAR(25),
  Reporting_amount FLOAT,
  Functional_amount FLOAT,
  Journal_line_description VARCHAR(250),
  Year_flag VARCHAR(25),
  Period_flag VARCHAR(25),
  Bu_id INT,
  Segment1_id INT,
  Segment2_id INT,
  Source_id INT,
  User_listing_id INT,
  Journal_type VARCHAR(25),
  ey_period VARCHAR(100)
) stored AS orc;
