CREATE TABLE salaries (
  yearID bigint,
  teamID string,
  lgID string,
  playerID string,
  salary bigint)
  stored as orc;

CREATE TABLE salaries_bucketed (
  yearID bigint,
  teamID string,
  lgID string,
  playerID string,
  salary bigint)
  CLUSTERED BY (playerID) sorted by (playerID) into 4 buckets
  stored as orc;

CREATE TABLE salaries_csv (
  yearID bigint,
  teamID string,
  lgID string,
  playerID string,
  salary bigint)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@HDFS_PATH@@/salaries.csv' into table salaries_csv;

insert into table salaries select * from salaries_csv;
insert into table salaries_bucketed select * from salaries_csv;