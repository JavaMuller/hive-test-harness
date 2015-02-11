CREATE TABLE master (
  playerID string,
  birthyear bigint,
  birthmonth bigint,
  birthday bigint,
  birthcountry string,
  birthstate string,
  birthcity string,
  deathyear bigint,
  deathmonth bigint,
  deathday bigint,
  deathcountry string,
  deathstate string,
  deathcity string,
  namefirst string,
  namelast string,
  namegiven string,
  weight bigint,
  height bigint,
  bats string,
  throws string,
  debut string,
  finalgame string)
  stored as orc;

CREATE TABLE master_csv (
  playerID string,
  birthyear bigint,
  birthmonth bigint,
  birthday bigint,
  birthcountry string,
  birthstate string,
  birthcity string,
  deathyear bigint,
  deathmonth bigint,
  deathday bigint,
  deathcountry string,
  deathstate string,
  deathcity string,
  namefirst string,
  namelast string,
  namegiven string,
  weight bigint,
  height bigint,
  bats string,
  throws string,
  debut string,
  finalgame string)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
  stored as TEXTFILE;

load data inpath '@@PATH@@/master.csv' into table master_csv;

insert into table master select * from master_csv;
