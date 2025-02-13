SELECT 

(SELECT ins.title FROM incident_status AS ins where ins.id = ai.incident_status_id) AS status_atual,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS responsavel,
ai.protocol AS protocolo,
a.responsible_id AS id_responsavel

FROM assignments AS a 

JOIN assignment_incidents AS ai ON ai.assignment_id = a.id


WHERE ai.incident_type_id IN (1291,1015,1291,1508,1509,1271)
AND a.responsible_id <> 89977
AND ai.incident_status_id NOT IN  (4,8)