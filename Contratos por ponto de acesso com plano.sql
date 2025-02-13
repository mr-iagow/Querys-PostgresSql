SELECT --DISTINCT ON (c.id)

ac.contract_id AS id_contrato,
(SELECT p.name FROM people AS p WHERE p.id = c.client_id) AS cliente,
p.phone AS telefone,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
sp.title AS plano,
c.amount AS valor_contrato

FROM authentication_contracts AS ac 
left JOIN contracts AS c ON c.id = ac.contract_id
--LEFT JOIN contract_items AS ci ON ci.contract_id = c.id 
left JOIN people AS p ON p.id = c.client_id
JOIN service_products AS sp ON sp.id = ac.service_product_id

WHERE 
ac.authentication_access_point_id IN (268,113)
AND p.name NOT LIKE '%PREFEITURA%'
AND c.amount BETWEEN 75.90 AND 109.90
AND c.id !=  54904
