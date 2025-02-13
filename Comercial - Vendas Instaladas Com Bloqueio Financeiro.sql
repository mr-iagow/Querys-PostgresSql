SELECT DISTINCT ON (c.id)
	c.id AS id_contrato,
	p.name AS cliente,
	DATE (a.created) AS data_abertura_os,
	CASE 
		WHEN c.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = c.created_by) 
		ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) 
		END AS vendedor_1,
	CASE 
		WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' 
		ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) 
		END AS equipe,
	p.cell_phone_1 AS celular_1,
	p.cell_phone_2 AS celular_2,
	p.phone AS telefone,
	c.v_status AS status_contrato
	
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
		AND c.company_place_id != 3
		AND c.v_status = 'Bloqueio Financeiro'
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
									AND c.v_status = 'Bloqueio Financeiro'
									AND DATE(a.conclusion_date) BETWEEN '2024-04-01' AND '2024-04-30'
						)
		AND ai.incident_status_id = 4 
		AND ai.incident_type_id IN (1005,1006)
		AND DATE(a.conclusion_date) >= DATE(c.created)
		AND c.v_status = 'Bloqueio Financeiro'
		AND DATE(a.conclusion_date) BETWEEN '2024-04-01' AND '2024-04-30'
		AND c.seller_1_id NOT IN (188, 129, 51)
	)
	
	OR
	
	(caa.activation_date BETWEEN '2024-04-01' AND '2024-04-30'
	AND c.seller_1_id NOT IN (188, 129, 51) 
	AND c.v_status = 'Bloqueio Financeiro'
        AND c.company_place_id != 3
	)