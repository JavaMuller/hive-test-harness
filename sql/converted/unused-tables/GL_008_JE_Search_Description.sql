CREATE TABLE GL_008_JE_Search_Description (
  Journal_entry_id VARCHAR(100),
  Journal_entry_line VARCHAR(100),
  Journal_line_description VARCHAR(250),
  Journal_entry_description VARCHAR(250),
  Journal_entry_type VARCHAR(25)
) stored AS orc;