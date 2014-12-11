CREATE TABLE Gregorian_calendar (
  date_id INT,
  calendar_date TIMESTAMP,
  month_id INT,
  month_desc VARCHAR(25),
  quarter_id INT,
  quarter_desc VARCHAR(25),
  year_id INT,
  day_number_of_week INT,
  day_of_week_desc VARCHAR(25),
  day_number_of_month INT,
  day_number_of_year INT,
  week_number_of_year INT
) stored AS orc;