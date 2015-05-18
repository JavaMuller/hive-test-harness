select
  m.playerid,
  m.namefirst,
  m.namelast,
  s.yearid,
  s.salary
from master m inner join salaries s on m.playerid = s.playerid order by m.playerid, s.yearid asc;