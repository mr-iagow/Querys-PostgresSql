SELECT DISTINCT ON (ai.protocol)

p.name AS atendente,
ai.protocol AS protocolo,
(SELECT  it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS solicitacao,
DATE (a.created) AS data_abertura,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS setor,
(SELECT bg.title FROM business_groups AS bg WHERE bg.id = p.business_group_id) AS equipe
 
FROM people AS p
INNER JOIN v_users AS v ON v.name = p.name
INNER JOIN assignments AS a ON a.created_by = v.id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE 

ai.origin_team_id = 1006
AND DATE (a.created)  BETWEEN '2025-01-01' AND '2025-05-22'
AND p.business_group_id IS NOT NULL