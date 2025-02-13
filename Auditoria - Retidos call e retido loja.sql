SELECT 

ai.protocol AS protocolo,
p."name" AS cliente,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.created_by) AS usuario_abertura,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento

FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN people AS p ON p.id = a.requestor_id


WHERE 
DATE (a.created) BETWEEN '2024-07-01' AND '2024-07-31'
and ai.incident_type_id IN (1345,1059)
AND a.company_place_id NOT IN (11,12,3)