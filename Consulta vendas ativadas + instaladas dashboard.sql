SELECT DISTINCT ON (c.id)
	(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
	p.name AS cliente,
	p.neighborhood AS bairro,
	p.city AS cidade,
	CONCAT(p.lat,',',p.lng) AS lat_long,
	p.lat AS latitude,
	p.lng AS longitude,
	CASE 
		WHEN ac.service_product_id IS NULL THEN (SELECT serv.title FROM service_products AS serv WHERE serv.id = ci.service_product_id)
		ELSE (SELECT serv.title FROM service_products AS serv WHERE serv.id = ac.service_product_id) 
		END  AS plano,
	CASE 
		WHEN ac.service_product_id IS NULL THEN (SELECT serv.selling_price FROM service_products AS serv WHERE serv.id = ci.service_product_id)
		ELSE (SELECT serv.selling_price FROM service_products AS serv WHERE serv.id = ac.service_product_id) 
		END AS valor_plano,
	CASE 
		WHEN c.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = c.created_by) 
		ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) 
		END AS vendedor_1,
	CASE 
		WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' 
		ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) 
		END AS equipe,
	CASE 
		WHEN caa.activation_date IS NULL THEN DATE(a.conclusion_date) 
		ELSE date(caa.activation_date) 
		END AS data_ativacao,
	
	CASE 
	WHEN LAST_VALUE(cev.month_year) OVER (PARTITION BY cev.contract_id ORDER BY cev.month_year asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) >= DATE(CURRENT_DATE)
   THEN c.amount - LAST_VALUE(cev.total_amount) OVER (PARTITION BY cev.contract_id ORDER BY cev.month_year asc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
   ELSE c.amount end AS valor_contrato_sub,
   
	nf.total_amount_products AS valor_produto,
	nf.total_amount_liquid AS valor_ativacao,
	CASE 
		WHEN nf.total_amount_products IS NULL THEN c.amount 
		WHEN nf.total_amount_liquid IS NULL THEN c.amount 
		ELSE c.amount + nf.total_amount_products + nf.total_amount_liquid 
		END AS total_recebido,
	(SELECT emp.description FROM companies_places AS emp WHERE emp.id = c.company_place_id) AS empresa,
	(SELECT cont.title FROM crm_contact_origins AS cont WHERE cont.id = org.crm_contact_origin_id) AS origem_contato,
	c.v_status AS status_contrato,
	c.v_stage AS estagio_contrato,
(select cco.title from crm_contact_origins as cco where cco.id = org.crm_contact_origin_id) AS origem_lead
	
	FROM 
		contracts AS c 
		JOIN people AS p ON p.id = c.client_id
		JOIN assignments AS a ON a.requestor_id = p.id 
		JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
		LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
		LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
		LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
		LEFT JOIN invoice_notes AS nf ON nf.id = caa.invoice_note_id
		LEFT JOIN people_crm_informations AS org ON p.id = org.person_id
		LEFT JOIN contract_items AS ci ON ci.contract_id = c.id
		LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id
		LEFT JOIN crm_person_oportunities AS cpo ON cpo.contact_id = c.id
		LEFT JOIN contract_eventual_values AS cev ON cev.contract_id = c.id AND cev.contract_event_type_id IS NOT NULL AND cev.contract_event_type_id IN (160,161,164,238,239,241,242,244,245,247,248,250,260) AND cev.deleted = false
	
	WHERE 
		(c.v_stage IN ('Em Aprovação','Pré-Contrato') 
		AND c.deleted = FALSE 
		AND ppg.people_group_id IS NOT NULL
		AND c.id IN (
							SELECT 
								c.id
								
								FROM 
									contracts AS c 
									JOIN people AS p ON p.id = c.client_id
									JOIN assignments AS a ON a.requestor_id = p.id
									JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
								WHERE 
									ai.incident_status_id = 4 
									AND ai.incident_type_id IN (1005,1006)
									AND DATE(a.conclusion_date) >= DATE(c.created)
									AND DATE(a.conclusion_date) BETWEEN cast(date_trunc('month', current_date-INTERVAL '5 month') as date) AND DATE(CURRENT_DATE)
						)
		AND ai.incident_status_id = 4 
		AND ai.incident_type_id IN (1005,1006)
		AND DATE(a.conclusion_date) >= DATE(c.created)
		AND DATE(a.conclusion_date) BETWEEN cast(date_trunc('month', current_date-INTERVAL '5 month') as date) AND DATE(CURRENT_DATE)
	)
	
	OR
	
	(caa.activation_date BETWEEN cast(date_trunc('month', current_date-INTERVAL '5 month') as date) AND DATE(CURRENT_DATE)
	AND ppg.people_group_id IS NOT NULL
	)