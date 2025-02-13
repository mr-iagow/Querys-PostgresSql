SELECT 

c.id AS cod_contrato,
p.name AS cliente,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato,
(SELECT sp.title FROM service_products AS sp where sp.id = ac.service_product_id) AS plano,
ac.user AS usuario_pppoe

FROM authentication_contracts AS ac
JOIN contracts AS c ON c.id = ac.contract_id
JOIN people AS p ON p.id = c.client_id

WHERE 

c.id IN (6194,46086)