CREATE TABLE GL_008_JE_Search_Amount (
  Journal_entry_id VARCHAR(100),
  Journal_entry_line VARCHAR(100),
  Journal_entry_description VARCHAR(250),
  Journal_entry_type VARCHAR(25),
  Reporting_amount FLOAT,
  Functional_amount FLOAT
) stored AS orc;
