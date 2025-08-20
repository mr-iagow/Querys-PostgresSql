SELECT DISTINCT ON (c.id)


c.id AS cod_contrato, 
p.name AS nome,
p.phone AS telefone_01,
p.cell_phone_1 AS telefone_02,
p.city AS cidade,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
c.amount AS valor,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
pat.title


FROM people AS p 
INNER JOIN 
	contracts AS c ON c.client_id = p.id
LEFT JOIN
	contract_service_tags AS tag ON c.id = tag.contract_id
LEFT JOIN 
	authentication_contracts AS ac ON c.id = ac.contract_id
LEFT JOIN
	service_products AS spr ON spr.id = ac.service_product_id
LEFT JOIN                                                     
	people_uploads AS pu ON pu.people_id = p.id  
LEFT JOIN
	patrimonies AS pat ON pat.contract_id = c.id  

WHERE
	c.v_stage ='Aprovado'
	AND c.v_status  IN ( 'Normal')
	-- AND c.amount = 75.90
	AND c.company_place_id NOT IN  (3,12)
	AND p.city IN ('Aracoiaba', 'Itaitinga', 'Maranguape', 'Pacatuba', 'Barreira','maracanau')
	AND spr.huawei_profile_name IN ('100M_STANDARD','200M_STANDARD','300M_STANDARD','600M_STANDARD')
	AND c.contract_type_id <>13
	--AND c.company_place_id IN (2,6,7)
	AND pat.patrimony_type_id <> 1
	


GROUP BY 	 1,2,3,4,5,6,7,8,9
HAVING MAX (pu.final) <='2025-08-01' OR MAX (pu.final) IS NULL