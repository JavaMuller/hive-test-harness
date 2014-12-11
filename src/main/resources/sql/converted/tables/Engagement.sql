CREATE TABLE Engagement (
  engagement_id string,
  engagement_desc VARCHAR(100),
  ver_start_date_id INT,
  ver_end_date_id INT,
  ver_desc VARCHAR(100)
) stored AS orc;