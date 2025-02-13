SELECT 

ai.protocol AS protocolo,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
(SELECT r.title FROM regions AS r WHERE r.id = a.region_id) AS regiao,
(SELECT it.title FROM incident_status AS it WHERE it.id = ai.incident_status_id) AS status,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe_vinculada_solicitacao

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 


WHERE 

a.region_id = 41
AND a.conclusion_date IS NULL 