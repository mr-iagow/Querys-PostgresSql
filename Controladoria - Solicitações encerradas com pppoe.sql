SELECT 
ai.protocol AS protocolo,
(SELECT p.name FROM people AS p WHERE p.id = ai.client_id) AS cliente,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE (a.conclusion_date) AS data_encerramento,
cst.service_tag AS etiqueta,
ac.user AS pppoe

FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
left JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
left JOIN authentication_contracts AS ac ON ac.contract_id = cst.contract_id

WHERE 
DATE (a.conclusion_date) BETWEEN '$encerramento01' AND '$encerramento02'
and ai.team_id IN (1003)
AND ai.incident_status_id IN (4)
