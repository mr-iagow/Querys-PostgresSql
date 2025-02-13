SELECT DISTINCT ON (ac.contract_id)
	ac.contract_id AS id_contrato,
	p.name AS cliente,
	pa.city AS cidade,
	pa.neighborhood AS bairro,
	ac.user as pppoe,
	(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS olt,
	c.v_stage AS estagio,
	c.v_status AS status,
   (SELECT bg.title FROM business_groups AS bg where bg.id = p.business_group_id) AS grupo,
	CASE WHEN c.seller_1_id IS NULL THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id =  c.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) END AS vendedor_1,
	CASE WHEN ppg.people_group_id IS NULL THEN 'Sem equipe' 
	ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
	(SELECT p.name FROM people AS p WHERE p.id = c.seller_2_id ) AS vendedor_2,
	(SELECT serv.title FROM service_products AS serv WHERE serv.id = ac.service_product_id) AS plano
-- 
FROM authentication_contracts AS ac
	JOIN contracts AS c ON c.id = ac.contract_id
	LEFT JOIN people AS p ON p.id = c.client_id
	LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
	left JOIN people_addresses AS pa ON pa.person_id = p.id

WHERE 
	--ac.service_product_id IN (3215,3241,3610,5810,5807,5809,5811,5812,5835,5808,5836)
	
	ac.service_product_id IN (5886,5876,5877,5878,5885,5836,5808,5835,5812,5811,5809,5807,5810,3190)