CREATE TABLE fielding (
  playerID string,
  yearID bigint,
  stint bigint,
  teamID string,
  lgID string,
  pos string,
  g bigint,
  gs bigint,
  innouts bigint,
  po bigint,
  a bigint,
  e bigint,
  dp bigint,
  pb bigint,
  wp string,
  sb bigint,
  cs bigint,
  zr string)
  stored as orc;

CREATE TABLE fielding_csv (
  playerID string,
  yearID bigint,
  stint bigint,
  teamID string,
  lgID string,
  pos string,
  g bigint,
  gs bigint,
  innouts bigint,
  po bigint,
  a bigint,
  e bigint,
  dp bigint,
  pb bigint,
  wp string,
  sb bigint,
  cs bigint,
  zr string)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@PATH@@/fielding.csv' into table fielding_csv;

insert into table fielding select * from fielding_csv;
