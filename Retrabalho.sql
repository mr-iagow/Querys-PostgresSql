SELECT DISTINCT ON (r.id)
-- r.id,
-- ai.protocol AS protocolo,
-- (SELECT it.title FROM incident_types AS it  WHERE it.id = ai.incident_type_id) AS tipo_OS,
-- (SELECT ist.title FROM incident_status AS ist WHERE ist.id = ai.incident_status_id) AS status_atual,
-- r.description,
-- DATE (a.created) AS data_abertura,
-- DATE (a.conclusion_date) AS encerramento,
-- r.progress,
-- r.title,
-- (SELECT v.name FROM v_users AS v WHERE v.id = r.modified_by) AS tecnico,
-- r.created
*

FROM assignments AS a
left JOIN assignment_incidents AS ai ON a.id = ai.assignment_id
left JOIN reports AS r ON a.id = r.assignment_id

WHERE
DATE (a.created) BETWEEN '2023-01-01' AND '2023-01-31'
-- AND r.title LIKE '%Atendimento Solicitação%'
-- AND r.progress = 100
AND ai.protocol = 1764263
AND r.id IN (4123675,4117279,4117276)

-- OR 
-- 
-- DATE (a.created) BETWEEN '2023-01-01' AND '2023-01-31'
-- AND r.title LIKE '%Reabertura (Retrabalho)%'
-- AND ai.protocol = 1764263











