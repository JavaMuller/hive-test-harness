CREATE TABLE Dim_Dates (
  calendar_date TIMESTAMP,
  date_id INT,
  month_id INT,
  month_desc VARCHAR(100),
  quarter_id INT,
  quarter_desc VARCHAR(100),
  year_id INT,
  day_number_of_week INT,
  day_of_week_desc VARCHAR(100),
  day_number_of_month INT,
  day_number_of_year INT,
  week_number_of_year INT
) stored AS orc;
