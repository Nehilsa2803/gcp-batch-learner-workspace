WITH player_runs AS (
    SELECT
        p.player_id,
        p.full_name,
        t.team_name,
        t.team_id,
        SUM(i.runs_scored) AS total_runs
    FROM teams t
    JOIN players p
        ON t.team_id = p.team_id
    JOIN innings i
        ON p.player_id = i.player_id
    GROUP BY
        p.player_id,
        p.full_name,
        t.team_id,
        t.team_name
)

SELECT
    full_name,
    team_name,
    total_runs,
    DENSE_RANK() OVER (
        PARTITION BY team_id
        ORDER BY total_runs DESC
    ) AS team_rank,
    ROUND(
        (total_runs * 100.0) /
        SUM(total_runs) OVER (PARTITION BY team_id),
        2
    ) AS percent_of_team_runs
FROM player_runs
ORDER BY team_name, team_rank;