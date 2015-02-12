CREATE TABLE schools (
  schoolID string,
  name string,
  city string,
  state string,
  nickname string)
  stored as orc;

CREATE TABLE schools_csv (
    schoolID string,
    name string,
    city string,
    state string,
    nickname string)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@PATH@@/schools.csv' into table schools_csv;

insert into table schools select * from schools_csv;