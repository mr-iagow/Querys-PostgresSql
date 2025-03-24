SELECT DISTINCT ON (ai.protocol)
p.name AS cliente,
pa.neighborhood AS bairro,
pa.city AS cidade,
ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
ct.amount AS valor_contrato,
ins.title AS insignia,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ci.service_product_id) AS plano

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN people AS p ON p.id = a.requestor_id 
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN people_addresses AS pa ON pa.person_id = p.id
JOIN contracts AS ct ON ct.client_id = p.id
LEFT JOIN insignias AS ins ON ins.id = p.insignia_id
LEFT JOIN contract_service_tags AS tag ON tag.contract_id = ct.id 
LEFT JOIN contract_items AS ci ON ci.contract_service_tag_id = tag.id

WHERE 
ai.incident_type_id in (1901,1899,1900,1971,1970,2175)
AND DATE (a.conclusion_date) BETWEEN '2025-03-01' AND '2025-03-24'
AND ai.incident_status_id = 4