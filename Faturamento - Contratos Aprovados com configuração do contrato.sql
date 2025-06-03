SELECT DISTINCT ON (c.id)
c.id AS id_contrato,
p.name AS cliente,
(SELECT cet.title FROM contract_event_types AS cet WHERE ce.contract_event_type_id = cet.id) AS evento,
(SELECT v.name FROM v_users AS v WHERE v.id = caa.modified_by) AS aprovador,
	cp."description" AS empresa,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.second_financial_operation_id) AS operacao_secundaria_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.second_financer_nature_id) AS natureza_secundaria_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS natureza_agrupador,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = ag.financial_collection_type_id) AS tipo_cobranca_agrupador
	
FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
JOIN companies_places AS cp ON cp.id = c.company_place_id
left JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id AND ag.financial_collection_type_id IS NOT NULL AND ag.financer_nature_id IS NOT NULL AND ag.deleted = false 

WHERE date(ce.created) BETWEEN '2025-05-01' AND '2025-06-02'
AND ce.contract_event_type_id = 3