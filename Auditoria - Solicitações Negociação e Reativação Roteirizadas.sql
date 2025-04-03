SELECT 

ai.protocol AS protocolo,
p.name AS cliente,
ins.title AS status,
TO_CHAR(a.created, 'DD/MM/YYYY HH24:MI:SS') AS data_abertura,
TO_CHAR(r.created, 'DD/MM/YYYY HH24:MI:SS') AS data_relato,
TO_CHAR(a.conclusion_date, 'DD/MM/YYYY HH24:MI:SS') AS data_encerramento,
r.description AS relato,
v.name AS relatado_por,
TO_CHAR(a.final_date, 'DD/MM/YYYY HH24:MI:SS') AS sla,
it.title AS tipo_solicitacao,
cp.description AS local_solicitacao

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN reports AS r ON r.assignment_id = ai.assignment_id
JOIN people AS p ON p.id = a.requestor_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
JOIN v_users AS v ON v.id = r.created_by
JOIN companies_places AS cp ON cp.id = a.company_place_id

WHERE 

ai.incident_type_id IN (1924,1287)
AND DATE (a.created) BETWEEN '2025-03-31' AND '2025-03-31'
and r."description" LIKE '%Encaminh%' 

ORDER BY ai.protocol