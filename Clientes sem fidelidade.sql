SELECT DISTINCT ON (c.id)
c.id AS cod_contrato, 
p.id AS cod_cliente,
P.cell_phone_1 AS numero_01,
p.phone AS numero_02,
p.name AS nome,
c.v_status AS status_contrato,
--c.created,
(SELECT tt.name FROM tx_types AS tt WHERE tt.id = p.type_tx_id) AS tipo_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
c.amount AS valor_contrato,
(SELECT sp.title FROM service_products AS  sp WHERE sp.id = ci.service_product_id) AS  plano




FROM contracts AS c
LEFT JOIN contract_items AS ci ON c.id = ci.contract_id
INNER JOIn people AS p ON c.client_id = p.id
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id 
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id 

	

WHERE
	c.v_stage ='Aprovado'
	 AND c.v_status  IN  ('Normal','Bloqueio Financeiro')
	 AND c.contract_type_id <> 13
	 AND p.type_tx_id =2
	 AND c.created <= '2022-04-14'
	AND p.type_tx_id = 2
	--*AND c.company_place_id IN (2,7,5,8,5,6)
	AND ac.authentication_access_point_id IN (113,268)
	--AND ci.service_product_id NOT IN (3540,3167,3183,3727,3716, 4245,4507, 4689,160,159,2761,2762,5525)	
GROUP BY (1,2,3,4,5,6,7,8,9,10,ci.service_product_id)

HAVING MAX (pu.final) <='2024-01-31' OR MAX (pu.final) IS NULL