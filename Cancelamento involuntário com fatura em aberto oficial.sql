SELECT DISTINCT ON (fat.id)
c.id AS cod_contrato,
p.id AS cod_cliente,
p.name AS cliente,
CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' WHEN p.type_tx_id != 1 THEN 'CPF' END AS tipo_cliente,
p.tx_id AS cpf_cnpj,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS logradouro,
p.number as numero_residencia,
p.address_complement AS complemento,
p.cell_phone_1 AS celular,
p.phone AS telefone,
c.amount AS valor_mensalidade,
(SELECT nf.title FROM financers_natures AS nf WHERE fat.financer_nature_id = nf.id) AS natureza_financeira,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = fat.financial_collection_type_id) AS tipo_cobranca,
fat.title_amount AS valor_em_aberto,

	CASE
		WHEN caa.activation_date IS NULL 
		THEN date(c.created)
		ELSE caa.activation_date
	END AS data_ativacao,
	
CASE WHEN ce.created = '0001-01-01 00:00:00' THEN date(ce.date) WHEN ce.created != '0001-01-01 00:00:00' THEN date(ce.created) END AS data_cancelamento,
CASE WHEN cet.id IN (184,214) THEN 'Involuntario' ELSE 'Voluntario' END AS tipo_cancelamento,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
(SELECT cet.title FROM contract_event_types AS cet where cet.id = ce.contract_event_type_id) AS evento_cancelamento,
c.v_status AS status_contrato,
c.cancellation_motive AS motivo_cancelamento,

	CASE 
		WHEN c.seller_1_id is null AND c.created_by != 1
		THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = c.created_by) 
		WHEN c.seller_1_id is null AND c.created_by = 1
		THEN 'MK Solutions'
		ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) 
	END AS vendedor,
	
    	LAST_VALUE((SELECT v.name FROM people AS v WHERE v.id = a.responsible_id)) OVER (
		  PARTITION BY c.id
        ORDER BY ai.protocol desc
        RANGE BETWEEN
            UNBOUNDED PRECEDING AND
            UNBOUNDED FOLLOWING
    ) instalador
   

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
INNER JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id
left JOIN assignment_incidents AS ai ON ai.contract_service_tag_id = ctag.id 
AND ai.incident_type_id IN (1005,1006,21)-- AND ai.incident_status_id = 4
LEFT JOIN assignments AS a ON a.id = ai.assignment_id
LEFT JOIN financial_receivable_titles AS fat ON fat.contract_id = c.id

WHERE 
date(ce.created) BETWEEN '2023-07-01' AND '2023-07-10'  AND ce.contract_event_type_id IN (184,214)
AND fat.p_is_receivable = TRUE