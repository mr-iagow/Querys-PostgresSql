SELECT DISTINCT ON (ai.protocol,ctag.id)
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS operador_abertura,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
ai.protocol AS protocolo,
p.name AS cliente,
DATE (a.created) AS data_abertura,
TO_CHAR(a.created, 'HH24:MI:SS') AS hora_abertura,
pa.city AS cidade,
ctag.service_tag AS etiqueta,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
sp.title AS plano,
c.amount AS valor_contrato

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN people AS p ON p.id = a.requestor_id
left JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts AS c ON c.id = ctag.contract_id
LEFT JOIN people_addresses AS pa ON pa.person_id = p.id
LEFT JOIN contract_items AS ci ON ci.contract_id = c.id AND ci.deleted = FALSE
LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id 

WHERE 
ai.incident_type_id IN(1984,1442,1059,2112)
and DATE (a.created) BETWEEN '2024-01-01' AND '2024-12-31'
--AND ai.team_id != 1083
AND a.created_by != 1
--AND ai.protocol = 2702744 
AND sp.huawei_profile_name IS NOT NULL 
AND sp.title NOT LIKE '%SCM%'
