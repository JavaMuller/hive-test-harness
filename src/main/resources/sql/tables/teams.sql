CREATE TABLE teams (
  yearID string,
  lgID string,
  teamID string,
  franchID string,
  divID string,
  Rank string,
  G string,
  GHome string,
  W string,
  L string,
  DivWin string,
  WCWin string,
  LgWin string,
  WSWin string,
  name string,
  park string,
  attendance string)
  stored as orc;

CREATE TABLE teams_csv (
  yearID string,
  lgID string,
  teamID string,
  franchID string,
  divID string,
  Rank string,
  G string,
  GHome string,
  W string,
  L string,
  DivWin string,
  WCWin string,
  LgWin string,
  WSWin string,
  name string,
  park string,
  attendance string)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@HDFS_PATH@@/teams.csv' into table teams_csv;

insert into table teams select * from teams_csv;