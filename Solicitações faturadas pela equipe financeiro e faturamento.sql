SELECT 
ai.protocol AS protocolo,
(SELECT p.name FROM people AS p where p.id = ai.client_id) AS cliente,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT v.name FROM v_users AS v WHERE v.id = sr.modified_by) AS faturado_por,
CASE 
	WHEN sr.deleted = TRUE THEN 'sim'
	WHEN sr.deleted = FALSE THEN 'não'
END AS deletado

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN sale_requests AS sr ON sr.id = ai.sale_request_id
LEFT JOIN v_users AS vu ON vu.id = sr.modified_by

WHERE 

DATE (sr.created) BETWEEN  '2023-09-01' AND '2023-11-30'
AND sr.modified_by IS NOT NULL 
--AND.sale_request_id IS IS NOT 
AND vu.team_id IN (2,1004)