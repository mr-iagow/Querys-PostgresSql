SELECT 

p.name AS nome_cliente,
c.id AS cod_contrato,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS rua,
ac.user AS pppoe,
ac.password AS senha_pppoe,
c.v_status AS status_contrato,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
(SELECT aap.title FROM authentication_access_points AS aap WHERE aap.id = ac.authentication_access_point_id) AS ponto_de_acesso

FROM authentication_contracts AS ac 
INNER JOIN contracts AS c ON c.id = ac.contract_id
INNER JOIN people AS p ON p.id = c.client_id

WHERE  c.v_status <>'Cancelado'
and ac.authentication_access_point_id = 11