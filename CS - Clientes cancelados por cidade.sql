SELECT DISTINCT ON (ci.contract_id)
		c.id AS id_contrato,
		c."description" AS desc_contrato,
		ctag.service_tag AS tag_contrato,
		c.v_status AS status_contrato,
		p.name AS cliente,
		ci.description AS plano,
		c.amount AS mensalidade,
		CASE WHEN c.cancellation_motive IS NULL THEN 'contrato_migrado' ELSE c.cancellation_motive END AS motivo_cancelamento,
		c.cancellation_date AS data_cancelamento

		
		
FROM contract_items AS ci
JOIN contracts AS c ON c.id = ci.contract_id
LEFT JOIN people AS p ON p.id = c.client_id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN authentication_contract_connection_occurrences AS accc ON accc.contract_id = c.id 
LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id

WHERE 
c.v_status = 'Cancelado'
AND DATE (c.cancellation_date) >= '2023-01-01'
AND ci.p_is_billable = TRUE
AND p.code_city_id = 2303931
--AND p.code_city_id = 2301000
--AND (p.city LIKE '%Aquiraz%' OR p.city LIKE '%AQUIRAZ%' OR p.city LIKE '%aquiraz%')
