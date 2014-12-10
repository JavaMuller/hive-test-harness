CREATE TABLE if not exists GL_018_KPIs_unpivot (
  source_id INT NOT NULL,
  source_ref varchar (200) NULL,
  source_group varchar (250) NULL,
  Source_Cd varchar (25) NULL,
  Source_Desc varchar (100) NULL,
--bu_id int NOT NULL,
  bu_ref varchar (125) NULL,
  bu_group varchar (125) NULL,
  Preparer_Name varchar (200) NULL,
  preparer_ref varchar (100) NULL,
  Preparer_department varchar (100) NULL,
  journal_type varchar (25) NULL,
  segment1_ref varchar (250) NULL,
  segment1_group varchar (250) NULL,
  segment2_ref varchar (250) NULL,
  segment2_group varchar (250) NULL,
  year_flag_desc varchar (200) NULL,
  period_flag_desc varchar (200) NULL,
  ey_period varchar (50) NULL,
  Ratio_type varchar (50) NULL,
  Ratio varchar (50) NULL,
  Amount FLOAT NULL,
  Multiplier INT NULL
)
