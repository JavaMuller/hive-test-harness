CREATE TABLE batting (
  playerID string,
  yearID bigint,
  stint bigint,
  teamID string,
  lgID string,
  g bigint,
  ab bigint,
  r bigint,
  h bigint,
  `2b` bigint,
  `3b` bigint,
  hr bigint,
  rbi bigint,
  sb bigint,
  cs bigint,
  bb bigint,
  so bigint,
  ibb bigint,
  hbp bigint,
  sh bigint,
  sf bigint,
  gidp bigint)
  stored as orc;

CREATE TABLE batting_csv (
  playerID string,
  yearID bigint,
  stint bigint,
  teamID string,
  lgID string,
  g bigint,
  ab bigint,
  r bigint,
  h bigint,
  `2b` bigint,
  `3b` bigint,
  hr bigint,
  rbi bigint,
  sb bigint,
  cs bigint,
  bb bigint,
  so bigint,
  ibb bigint,
  hbp bigint,
  sh bigint,
  sf bigint,
  gidp bigint)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@HDFS_PATH@@/batting.csv' into table batting_csv;

insert into table batting select * from batting_csv;