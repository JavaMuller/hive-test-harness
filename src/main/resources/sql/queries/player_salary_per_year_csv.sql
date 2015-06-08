select
  m.playerid,
  m.namefirst,
  m.namelast,
  s.yearid,
  s.salary
from salaries_csv s inner join master_csv m on s.playerid = m.playerid
where s.yearid = 2000;