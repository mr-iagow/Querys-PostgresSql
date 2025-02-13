SELECT

ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status,
a.description AS texto_solicitacao


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE 

a.conclusion_date BETWEEN '2021-01-01' AND '2022-01-30'
and ai.incident_type_id IN (1318,1362,1317)
AND ai.incident_status_id IN (4,8)