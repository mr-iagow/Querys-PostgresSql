SELECT --DISTINCT ON (ci.contract_id)
		p.name AS Nome, 
		p.name_2 AS Apelido,
		CASE 
		WHEN p.type_tx_id = 2 THEN '2'
		WHEN p.type_tx_id = 1 THEN '1'
		END AS Tipo_de_pessoa,
		p.tx_id AS cpf_cnpj,
		p.birth_date AS data_de_aniversario_fundacao,
		p.phone AS telefone,
		p.cell_phone_1 AS celular,
		case
		WHEN p.cell_phone_1_has_whatsapp =  TRUE THEN 'sim'
		WHEN p.cell_phone_1_has_whatsapp =  false THEN 'nao'
		END AS whatsapp,	
		case
		WHEN p.cell_phone_1_has_telegram =  TRUE THEN 'sim'
		WHEN p.cell_phone_1_has_telegram =  false THEN 'nao'
		END AS telegram,
		p.email AS email,
		pa.postal_code AS cep,
		pa.street_type AS tipo_de_logradouro,
		pa.street AS logradouro,
		p.number AS numero,
		pa.address_complement AS complemento,
		pa.address_reference AS referencia,
		pa.neighborhood AS bairro,
		pa.city AS municipio,
		pa.state AS estado,
		pa.country AS pais,
		pa.code_city_id AS cod_IBGE,
		p.website AS website
		
FROM contract_items AS ci
JOIN contracts AS c ON c.id = ci.contract_id
LEFT JOIN people AS p ON p.id = c.client_id
LEFT JOIN contract_events AS ce ON ce.contract_id = c.id
left JOIN people_addresses AS pa ON pa.person_id = p.id

WHERE 

DATE (ce.created) BETWEEN '2023-09-01' AND '2023-11-22'
AND  ce.contract_event_type_id = 184
AND c.company_place_id IN (2,7,5,6)
and ci.p_is_billable = TRUE

