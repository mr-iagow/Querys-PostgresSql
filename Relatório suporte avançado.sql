SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
(SELECT v.name FROM v_users AS v WHERE v.id = r.created_by) AS responsavel_encerramento,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS responsavel_encerramento,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
CASE 
WHEN a.conclusion_date < a.final_date THEN 'No Prazo' 
WHEN a.conclusion_date > a.final_date THEN 'Fora do Prazo' 
END AS SLA


FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN reports AS r ON r.assignment_id = a.id

WHERE 
DATE (a.conclusion_date) BETWEEN '2023-04-01' AND '2023-04-30'
and ai.team_id IN (1037,1042,1040)
AND ai.incident_status_id = 4
AND r.progress >= 100
AND r.created_by IN (258,122)