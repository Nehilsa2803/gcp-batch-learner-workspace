with cte1 as
  (
    select match_id,
       player_id,
       runs_scored 
    from innings
  )
 select full_name,
       team_name,
       count(match_id),
       sum(runs_scored)
 from teams t
       join 
      players p
       on t.team_id=p.team_id
       join cte1 c
       on p.player_id=c.player_id
  group by p.player_id,
           p.full_name,
           t.team_name
  having count(match_id)>2
 order by sum(runs_scored) desc