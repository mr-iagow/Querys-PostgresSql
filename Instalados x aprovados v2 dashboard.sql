SELECT DISTINCT ON (c.id)
    c.id AS id_contrato,
    p.name AS cliente,
    c.v_status AS status_contrato,
    p.city AS cidade_cliente,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
    (SELECT cet.title FROM contract_event_types AS cet WHERE ce.contract_event_type_id = cet.id) AS evento,
    (SELECT v.name FROM v_users AS v WHERE v.id = caa.modified_by) AS aprovador_por, 
    c.amount AS valor_contrato,
    con.description AS plano,
    caa.activation_date AS data_ativacao,
    CASE 
	WHEN ce.created = '0001-01-01 00:00:00' 
	THEN DATE(ce.date) 
	WHEN ce.created != '0001-01-01 00:00:00' 
	THEN DATE(ce.created) 
	END AS data_aprovacao,
    CASE 
	WHEN EXTRACT(DOW FROM caa.activation_date) = 6 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (1,2,3,4,5)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -2
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 6 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -1

	WHEN EXTRACT(DOW FROM caa.activation_date) = 5 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1,2,3,4)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -2
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 4 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1,2,3)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -2
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 4 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -1
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 3 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1,2)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -2
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 3 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -1
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 2 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -2
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 2 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -1
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 1 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -1
	
	WHEN EXTRACT(DOW FROM caa.activation_date) = 0 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (1,2,3,4,5,6)
	THEN DATEDIFF (date(ce.created), caa.activation_date) -1
	
	ELSE DATEDIFF (date(ce.created), caa.activation_date)
	END AS diferenca_dias,

CASE 
	WHEN 
	(
		CASE 
			WHEN EXTRACT(DOW FROM caa.activation_date) = 6 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (1,2,3,4,5)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -2
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 6 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -1
		
			WHEN EXTRACT(DOW FROM caa.activation_date) = 5 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1,2,3,4)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -2
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 4 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1,2,3)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -2
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 4 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -1
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 3 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1,2)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -2
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 3 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -1
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 2 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (0,1)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -2
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 2 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -1
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 1 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (6)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -1
			
			WHEN EXTRACT(DOW FROM caa.activation_date) = 0 AND EXTRACT(DOW FROM CASE WHEN ce.created = '0001-01-01 00:00:00' THEN DATE(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN DATE(ce.created) END) IN (1,2,3,4,5,6)
			THEN DATEDIFF (date(ce.created), caa.activation_date) -1
			
			ELSE DATEDIFF (date(ce.created), caa.activation_date)
			END
	)	>= 3 
	THEN 'Atrasado'
	ELSE 'No prazo'
	END AS status
    
FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
LEFT JOIN service_products AS sp ON sp.id = con.service_product_id

WHERE date(ce.created) BETWEEN '2023-11-01' AND '2023-11-30'
AND ce.contract_event_type_id = 3
ORDER BY c.id, con.description, ce.created DESC;
