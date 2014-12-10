CREATE TABLE if not exists Dim_Dates (
  calendar_date DATETIME NULL,
  date_id INT NOT NULL,
  month_id INT NULL,
  month_desc varchar (100) NULL,
  quarter_id INT NULL,
  quarter_desc varchar (100) NULL,
  year_id INT NULL,
  day_number_of_week INT NULL,
  day_of_week_desc varchar (100) NULL,
  day_number_of_month INT NULL,
  day_number_of_year INT NULL,
  week_number_of_year INT NULL
)
