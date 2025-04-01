SELECT 

p."name" AS colaborador,
(SELECT t.title FROM teams AS t WHERE t.id = pt.team_id ) AS equipe

FROM people AS p
JOIN people_teams AS pt ON pt.person_id = p.id
JOIN v_users AS v ON v.tx_id = p.tx_id

WHERE 

pt.team_id IN(1037,1040, 1080, 1006)
ORDER BY equipe