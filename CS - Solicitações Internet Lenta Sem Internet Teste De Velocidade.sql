SELECT DISTINCT ON (ai.protocol)

a.created AS data_hora,
it.title AS tipo_solicitacao,
ai.protocol AS protocolo,
p.name AS cliente,
ctag.service_tag AS tag,
pa.city AS cidade,
pa.neighborhood AS bairro,
CASE WHEN sp.title IS NULL THEN sp1.title ELSE sp.title END AS teste,
ct.v_status AS status_contrato



FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN people AS p ON p.id = ai.client_id
JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts AS ct ON ct.id = ctag.contract_id
LEFT JOIN people_addresses AS pa ON pa.id = ct.people_address_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
left JOIN authentication_contracts AS ac ON ac.contract_id = ct.id
LEFT JOIN service_products AS sp1 ON sp1.id = ac.service_product_id
LEFT JOIN contract_items AS ci ON ci.contract_id = ct.id AND ci.deleted = FALSE --AND ci.contract_service_tag_id = ctag.id
LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id AND sp.huawei_profile_name IS NOT NULL 


WHERE 

ai.incident_type_id IN (1073,1069,1061)
AND DATE (a.created) BETWEEN '2025-09-01' AND '2025-11-22'
--AND ai.protocol = 3254922
--AND ci.p_is_billable = TRUE

