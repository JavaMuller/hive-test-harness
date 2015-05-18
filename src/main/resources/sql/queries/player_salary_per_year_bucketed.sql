select
  m.playerid,
  m.namefirst,
  m.namelast,
  s.yearid,
  s.salary
from master_bucketed m inner join salaries_bucketed s on m.playerid = s.playerid order by m.playerid, s.yearid asc;