SELECT 
(SELECT p.name FROM people AS p WHERE p.id = ai.client_id) AS cliente,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT v.name FROM people AS v WHERE v.id = sr.cancellation_responsible_id) AS usuario_faturamento,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
sr.cancellation_justify AS justificativa_cancelamento,
(SELECT srm.title FROM solicitation_routing_motives AS srm WHERE srm.id = sr.cancellation_motive_id) AS motivo_cancelamento

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN sale_requests AS sr ON sr.id = ai.sale_request_id

WHERE 
sr.cancellation_motive_id IS NOT NULL 
AND sr.modified BETWEEN '2024-06-01' AND '2024-06-27'
