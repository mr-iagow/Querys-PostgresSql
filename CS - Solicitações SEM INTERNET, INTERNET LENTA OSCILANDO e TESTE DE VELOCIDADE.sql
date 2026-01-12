SELECT 
ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
p."name" AS cliente,
DATE (a.created) AS data_abertura,
p.city AS cidade,
p.neighborhood AS bairro,
c.v_status AS status_comtrato


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN people AS p ON p.id = ai.client_id
JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
JOIN contracts AS c ON c.id = ctag.contract_id

WHERE it.id IN (2140, 2007, 1073, 1069, 2015, 2165, 2019, 2162, 1130, 1389, 1061)
AND DATE (a.created) BETWEEN '2024-01-01' AND '2025-12-30'