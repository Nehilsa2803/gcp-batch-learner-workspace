select team_name,
sum(runs_scored) as total_run_by_team,
round(sum(runs_scored)*100/sum(balls_faced),2) as strike_rate
from teams t join players p 
on t.team_id=p.team_id
left join innings i
on i.player_id=p.player_id
group by t.team_name