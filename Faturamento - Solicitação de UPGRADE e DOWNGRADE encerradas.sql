SELECT --DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
(SELECT distinct ON (c.client_id) cp.description
 FROM companies_places AS cp 
 JOIN contracts AS c ON cp.id = c.company_place_id 
 WHERE c.client_id = a.requestor_id) AS local_contrato,
 (SELECT distinct ON (c.client_id) c.id AS id_contrato
 FROM companies_places AS cp 
 JOIN contracts AS c ON cp.id = c.company_place_id
 WHERE c.client_id = a.requestor_id) AS id_contrato,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS responsavel_encerramento,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT it.title FROM incident_status AS it WHERE it.id = ai.incident_status_id) AS status

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN people AS pp ON pp.id = a.requestor_id

WHERE 

ai.incident_type_id IN (51,1017,1606,52,1604,1605)
AND DATE (a.conclusion_date) BETWEEN '2024-03-14' AND '2024-03-27'
AND ai.incident_status_id = 4
