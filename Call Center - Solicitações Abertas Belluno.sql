SELECT 

ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
t.title AS equipe,
v."name" AS responsavel_abertura,
CASE WHEN p.name IS NULL THEN 'sem atendente' ELSE p."name" END AS responsalve_encerramento,
DATE (a.created) AS data_abertura,
TO_CHAR(a.created, 'HH24:MI:SS') AS hora_abertura,
DATE (a.conclusion_date) AS data_encerramento,
TO_CHAR(a.conclusion_date, 'HH24:MI:SS') AS hora_encerramento,
a.final_date AS prazo,
CASE 
	WHEN a.conclusion_date > a.final_date THEN 'fora do prazo'
	WHEN a.conclusion_date <= a.final_date THEN 'dento do prazo'
END AS sla,
ins.title AS status

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN teams AS t ON t.id = ai.team_id
JOIN v_users AS v ON v.id = a.created_by
LEFT JOIN people AS p on p.id = a.responsible_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id

WHERE 

DATE (a.created) BETWEEN '2025-04-01' AND '2025-04-02'  
AND v.id = 206 --Usuário Belluno