SELECT
p.name AS nome_cliente,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it  WHERE it.id = ai.incident_type_id) AS tipo_OS,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ist.title FROM incident_status AS ist WHERE ist.id = ai.incident_status_id) AS status_atual,
(SELECT te.title FROM teams AS te WHERE te.id = ai.team_id) AS equipe,
r.title AS evento,
(SELECT p.name FROM v_users AS p WHERE p.id = r.modified_by) AS tecnico,
r.description AS encerramento 

FROM reports AS r
INNER JOIN assignment_incidents AS ai ON r.assignment_id = ai.assignment_id
INNER JOIN assignments AS a ON a.id = ai.assignment_id
LEFT JOIN people AS p ON p.id = ai.client_id

WHERE 
ai.team_id IN (1030,1046,1049,1054,1053,1052,1048,1047,1036,1034,1031,1035,1029,1032,1003,1033)
AND a.created BETWEEN '2023-02-12' AND '2023-02-15'
and r.title LIKE '%Reabertura (Retrabalho)%'

OR
ai.team_id IN (1030,1046,1049,1054,1053,1052,1048,1047,1036,1034,1031,1035,1029,1032,1003,1033)
AND a.created BETWEEN '2023-02-12' AND '2023-02-14'
and r.title LIKE '%Atendimento%'
AND r.progress >= 100
AND r.final_geoposition_latitude IS NOT NULL
AND ai.protocol IN (
	select
	ai.protocol
	
	FROM reports AS r
	INNER JOIN assignment_incidents AS ai ON r.assignment_id = ai.assignment_id
	INNER JOIN assignments AS a ON a.id = ai.assignment_id
	LEFT JOIN people AS p ON p.id = ai.client_id
	
	WHERE 
	ai.team_id = 1003
	AND a.created BETWEEN '2023-02-12' AND '2023-02-14'
	and r.title LIKE '%Reabertura (Retrabalho)%'	
)