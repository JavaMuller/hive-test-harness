CREATE TABLE GL_008_JE_Search_Amount (
  Journal_entry_id VARCHAR(100) NULL,
  Journal_entry_line VARCHAR(100) NULL,
  Journal_entry_description VARCHAR(250) NULL,
  Journal_entry_type VARCHAR(25) NULL,
  Reporting_amount FLOAT NULL,
  Functional_amount FLOAT NULL
) stored AS orc;
