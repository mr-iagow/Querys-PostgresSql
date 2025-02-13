SELECT DISTINCT ON (ai.protocol)
		c.id AS id_contrato,
		p.id AS id_cliente, 
		p.name AS cliente,
		(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
		ai.protocol AS protocolo,
		(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS operador_abertura,
		(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS motivo_cancelamento,
		ci.description AS plano,
		c.amount AS valor_contrato,
		pa.city AS cidade,
		pa.neighborhood AS bairro,
		c.beginning_date AS data_inicial_fidelidade,
		FIRST_VALUE(pu.begin) OVER (PARTITION BY c.client_id) AS arquivo_fidelidade_mais_recente

FROM contract_items AS ci
JOIN contracts AS c ON c.id = ci.contract_id
JOIN contract_events AS ce ON c.id = ce.contract_id
JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN people AS p ON p.id = c.client_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id 
LEFT JOIN assignments AS a ON a.requestor_id = p.id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_incident_types AS scmi ON scmi.solicitation_category_matrix_id = ssc.id
LEFT JOIN people_addresses AS pa ON pa.person_id = p.id 


WHERE 
DATE (a.created) BETWEEN '2024-08-01'AND '2024-10-31'
AND ai.incident_status_id = 4
AND ai.incident_type_id = 1442
AND ci.p_is_billable = TRUE
AND ssc.service_category_id_4 IN (371,368)
