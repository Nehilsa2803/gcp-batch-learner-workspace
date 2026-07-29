select full_name,
team_name,
role 
from teams t join players p
on t.team_id=p.team_id
where role='Batsman'
     and 
 nationality ='Indian'