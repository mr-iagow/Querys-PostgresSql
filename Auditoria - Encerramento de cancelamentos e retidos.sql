SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
ctag.service_tag,
c.id AS id_contrato,
p.name AS cliente,
c.v_status AS status_contrato,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS aberto_por,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao



FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN people AS p ON p.id = a.requestor_id 
JOIN people_addresses AS pa ON pa.person_id = p.id
left JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
left JOIN contracts AS c ON c.id = ctag.contract_id

WHERE 
ai.incident_type_id in (1059, 1345, 1442)
AND DATE (a.conclusion_date) BETWEEN '2024-08-01' AND '2024-08-31'
AND ai.incident_status_id = 4

