CREATE TABLE if not exists GL_008_JE_Search_Amount (
  Journal_entry_id varchar (100) NULL,
  Journal_entry_line varchar (100) NULL,
  Journal_entry_description varchar (250) NULL,
  Journal_entry_type varchar (25) NULL,
  Reporting_amount FLOAT NULL,
  Functional_amount FLOAT NULL
)
