SELECT 
p.name AS nome_cliente,
(SELECT it.title FROM incident_types AS it  WHERE it.id = ai.incident_type_id) AS tipo_OS,
ai.protocol AS protocolo,
r.title AS evento_retrabalho,
r.description AS motivo_retrabalho,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS tecnico,
(SELECT MAX (r.description) FROM reports AS r WHERE a.id = r.assignment_id and r.title LIKE '%Atendimento%'  AND ai.incident_status_id = 4 AND r.progress >=100 /*AND r.type IS NOT NULL*/ 
) AS relato_encerramento

FROM reports AS r
INNER JOIN assignments AS a ON a.id = r.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN people AS p ON p.id = ai.client_id

WHERE 
ai.team_id = 1003
AND a.created BETWEEN '2023-01-01' AND '2023-02-18'
AND ai.incident_status_id = 4
AND r.title LIKE '%Reabertura (Retrabalho)%'

-- OR 
-- 
-- r.title LIKE '%Atendimento%'
-- AND r.type =2
-- AND a.created BETWEEN '2023-01-01' AND '2023-01-31'
-- and ai.team_id = 1003
-- AND ai.incident_status_id = 4
-- AND r.reopen = 1 
-- -- AND r.final_geoposition_latitude IS NOT NULL 
-- AND r.progress >=100
-- 
-- GROUP BY 1,2,3,4,6,7,8,9
-- 


