CREATE TABLE schools (
  schoolID string,
  schoolName string,
  schoolCity string,
  schoolState string,
  schoolNick string)
  stored as orc;

CREATE TABLE schools_csv (
  schoolID string,
  schoolName string,
  schoolCity string,
  schoolState string,
  schoolNick string)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@PATH@@/schools.csv' into table schools_csv;

insert into table schools select * from schools_csv;