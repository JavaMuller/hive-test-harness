CREATE TABLE if not exists GL_008_JE_Search (
  Journal_entry_id varchar (100) NULL,
  Journal_entry_line varchar (100) NULL,
  Journal_entry_description varchar (250) NULL,
  Journal_entry_type varchar (25) NULL,
  Reporting_amount FLOAT NULL,
  Functional_amount FLOAT NULL,
  Journal_line_description varchar (250) NULL,
  Year_flag varchar (25) NULL,
  Period_flag varchar (25) NULL,
  Bu_id INT NULL,
  Segment1_id INT NULL,
  Segment2_id INT NULL,
  Source_id INT NULL,
  User_listing_id INT NULL,
  Journal_type varchar (25) NULL,
  ey_period varchar (100) NULL
)
