SELECT DISTINCT ON (ci.contract_id)
		c.id AS id_contrato,
		p.id AS id_cliente, 
		p.name AS cliente,
		(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
		ci.description AS plano,
		p.city AS cidade,
		ce.description AS motivo_cancelamento,
		(SELECT ce.title FROM contract_event_types AS ce WHERE ce.id = cet.id) AS evento_cancelamento,
		DATE (ce.created) AS data_cancelamento,
		c.v_status AS status_contrato

FROM contract_items AS ci
JOIN contracts AS c ON c.id = ci.contract_id
JOIN contract_events AS ce ON c.id = ce.contract_id
JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN people AS p ON p.id = c.client_id

WHERE 
		ci.p_is_billable = TRUE
		AND c.v_status = 'Cancelado'
		AND date(ce.created) BETWEEN '2022-05-01' AND '2023-05-10'
		AND cet.id IN (110, 144, 163, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 194, 195, 196, 197, 198, 199, 201, 202, 203, 204, 214, 225, 226, 237, 251, 252, 261, 200, 267, 191, 192, 193, 205, 264, 265, 266, 270, 24)
		AND c.company_place_id <> 3
		AND c.client_id NOT IN (SELECT DISTINCT ON (c.id)

c.client_id

FROM contracts AS C 
left JOIN financial_receivable_titles AS frt ON frt.contract_id = c.id
left JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id

WHERE 

frtt.receipt_date IS NULL )
