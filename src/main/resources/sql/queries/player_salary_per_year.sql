select
  m.playerid,
  m.namefirst,
  m.namelast,
  s.yearid,
  s.salary
from salaries s inner join master m on s.playerid = m.playerid
where s.yearid = 2000;