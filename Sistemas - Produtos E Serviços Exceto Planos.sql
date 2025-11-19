SELECT 

sp.code AS codigo,
sp.title AS descricao,
um.title AS unidade,
spg.title as grupo,
CASE
	WHEN sp.active = true THEN 'Sim'
   ELSE 'Não'
END AS ativo,
CASE
	WHEN sp.generate_patrimony = true THEN 'Sim'
   ELSE 'Não'
END AS gera_patrimonio,
sp.selling_price AS valor_venda

FROM service_products AS sp
LEFT join units_measures AS um ON um.id = sp.first_unit
left JOIN service_product_groups AS spg ON spg.id = sp.service_product_group_id

WHERE sp."type" = 1