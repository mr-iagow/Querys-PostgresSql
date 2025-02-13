SELECT DISTINCT ON (ci.contract_id)
		c.id AS id_contrato,
		p.id AS id_pessoa,
		c.description AS descricao,
		p.name AS cliente,
		p.tx_id AS cpf,
		p.state AS estado,
		p.street AS rua,
		p.street_type AS tipo_rua,
		p.postal_code AS cep,
		p.number AS numero,
		p.address_complement AS complemento,
		p.neighborhood AS bairro,
		p.city AS cidade,
		p.country AS pais,
		p.address_reference AS referencia,
		p.cell_phone_1 AS celular_1,
		p.cell_phone_2 AS celular_2,
		p.phone AS telefone,
		CASE
			WHEN ac.user IS NOT NULL THEN ac.user 
			WHEN ac.user IS NULL THEN accc.user
		END AS usuario,
		(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
		ci.description AS plano,
		c.v_status AS status_contrato
		
FROM contract_items AS ci
JOIN contracts AS c ON c.id = ci.contract_id
LEFT JOIN people AS p ON p.id = c.client_id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN authentication_contract_connection_occurrences AS accc ON accc.contract_id = c.id 

WHERE 
c.beginning_date <='2021-11-30'
AND ci.p_is_billable = TRUE
AND p.code_city_id IN  (2301000,2310852,2301000,2303501,2302206)
--AND p.code_city_id = 2301000
--AND (p.city LIKE '%Aquiraz%' OR p.city LIKE '%AQUIRAZ%' OR p.city LIKE '%aquiraz%')
