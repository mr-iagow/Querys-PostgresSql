SELECT DISTINCT ON (ai.protocol)
	p.name AS atendente,
	c.amount AS valor,
	ai.protocol AS protocolo,
	(SELECT   it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS solicitacao,
	pa.city AS cidade,
	pa.neighborhood AS bairro,
	CASE
		WHEN ai.incident_type_id IN (51,1017,1821) AND p.business_group_id NOT IN (5)THEN 2.5
		WHEN ai.incident_type_id IN (1604,1605,1823) AND p.business_group_id NOT IN (5) THEN  1.5
		WHEN ai.incident_type_id IN (1606,52,1822,1823) AND  p.business_group_id NOT IN (5) AND c.amount >= 99.90 THEN 1
		WHEN ai.incident_type_id IN (1606,52,1822,1823) AND  p.business_group_id IN (5) AND c.amount >= 99.90 THEN 1
		WHEN ai.incident_type_id IN (51,1017,1604,1605,1823,1821) AND p.business_group_id IN (5)THEN 1
	END AS pontuacao,
	ai.incident_type_id,
	CASE
		WHEN p.business_group_id IN (2,3) THEN 'Smart Omini'
		WHEN p.business_group_id IN (5) THEN 'Lojas'
		ELSE 'Telefonia'
	END AS canal,
	pa.street AS rua,
	CONCAT (pa.neighborhood,' - ',pa.city) Bairro_cidade,
	CONCAT (pa.street,' - ',pa.city) AS rua_cidade,
	DATE (a.created) AS data_abertura,
	DATE (a.conclusion_date) AS data_encerrramento,
	(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS setor,
	(SELECT bg.title FROM business_groups AS bg WHERE bg.id = p.business_group_id) AS equipe,
	(SELECT sp.title FROM service_products AS sp WHERE sp.id = ci.service_product_id) AS plano

FROM people AS p
	INNER JOIN v_users AS v ON v.name = p.name
	LEFT JOIN assignments AS a ON a.created_by = v.id
	LEFT JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
	left JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
	JOIN contracts AS c ON c.id = cst.contract_id
	LEFT JOIN people_addresses AS pa ON pa.person_id = a.requestor_id
	LEFT JOIN authentication_contracts AS ci ON ci.contract_id = c.id
	LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id 

WHERE 
	DATE (a.conclusion_date) BETWEEN '2023-07-01' AND DATE(CURRENT_DATE) 
	AND ai.incident_type_id IN (51,52,1017,1604,1605,1606,1822,1823,1821)
	and p.business_group_id IS NOT NULL
	AND ai.incident_status_id = 4
	AND v.team_id IN (1,1006)
