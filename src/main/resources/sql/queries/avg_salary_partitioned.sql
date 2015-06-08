select
  avg(salary)
from salaries_partitioned
where yearid = 2000;