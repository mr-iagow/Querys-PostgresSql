SELECT 
SUBSTR (p.name, 0, STRPOS(p.name,' ')) AS primero_nome,
p.id AS id_cliente,
c.id AS cod_contrato,
p.cell_phone_1 AS telefone_1,
p.phone AS telefone_2,
c.v_status AS status_contrato,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
c.amount AS valor_plano


from authentication_contracts AS ac 
LEFT JOIN contracts AS c ON c.id = ac.contract_id
JOIN people AS p ON p.id = c.client_id

WHERE ac.authentication_access_point_id = 139

AND c.v_status = 'Normal'