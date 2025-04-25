SELECT DISTINCT ON (ct.id)

		ct.contract_number AS numero_contrato,
		ct.v_status AS status_contrato,
		pp.name AS cliente,
		ins.title AS insignia,
		pp.phone AS telefone,
		pp.cell_phone_1 AS celular1,
		pp.cell_phone_2 AS celular2,
		pa.city AS cidade,
		pa.neighborhood AS bairro,
		sp.title AS plano,
		ct.amount AS valor_contrato,
		ct.collection_day AS vencimento

FROM contracts AS ct
	JOIN people AS pp ON pp.id = ct.client_id
	LEFT JOIN insignias AS ins ON ins.id = pp.insignia_id
	JOIN people_addresses AS pa ON pa.person_id = pp.id
	JOIN contract_items AS ci ON ci.contract_id = ct.id 
	JOIN service_products AS sp ON sp.id = ci.service_product_id AND sp.huawei_profile_name IS NOT NULL 

WHERE 
	DATE (ct.created) BETWEEN '$data01' AND '$data02'
	AND ct.company_place_id != 3
	AND ct.contract_type_id NOT IN (6,7)
	