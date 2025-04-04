SELECT 
ai.protocol AS protocolo,
p.name AS cliente,
ins.title AS status,
r."description",
(SELECT p.name FROM people AS p WHERE p.id = r.person_id) AS cancelado_por,
TO_CHAR(a.created, 'DD/MM/YYYY HH24:MI:SS') AS data_abertura,
TO_CHAR(a.conclusion_date, 'DD/MM/YYYY HH24:MI:SS') AS data_encerramento_cancelamento,
TO_CHAR(a.final_date, 'DD/MM/YYYY HH24:MI:SS') AS sla,
it.title AS tipo_solicitacao

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN people AS p ON p.id = a.requestor_id
join incident_types AS it ON it.id = ai.incident_type_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
JOIN reports AS r ON r.assignment_id = a.id

WHERE 
ai.team_id = 1003
AND ai.origin_team_id = 1006
and DATE (a.created) BETWEEN '2025-03-01' AND '2025-03-31'
AND r.progress >= 200
AND ins.id = 8
AND r.person_id IN (88636,103406,103406,115620,125754)

