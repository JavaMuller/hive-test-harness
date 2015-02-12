CREATE TABLE college_playing (
    playerID string,
  schoolID string,
  year int)
  stored as orc;

CREATE TABLE college_playing_csv (
    playerID string,
    schoolID string,
    year int)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@PATH@@/college_playing.csv' into table college_playing_csv;

insert into table college_playing select * from college_playing_csv;