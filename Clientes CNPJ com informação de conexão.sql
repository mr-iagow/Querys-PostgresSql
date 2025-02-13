SELECT 

p.name AS cliente,
p.city AS cidade,
p.neighborhood AS bairro,
ct.v_status AS status_contrato,
CASE WHEN ac.ip_type = 1 THEN 'IP Fixo' WHEN ac.ip_type != 1 THEN 'Pelo CE' END AS tipo_IP,
aip.ip AS IP,
(SELECT acp.title FROM authentication_concentrators AS acp WHERE acp.id = ac.authentication_concentrator_id) AS concentrador,
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS Ponto_de_Acesso,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS Plano,
ac.user AS PPPOE

FROM contracts AS ct
JOIN authentication_contracts AS ac ON ac.contract_id = ct.id
LEFT JOIN people AS p ON p.id = ct.client_id
LEFT JOIN authentication_ips AS aip ON aip.id = ac.ip_authentication_id

WHERE 
p.type_tx_id =  1
AND ct.v_status != 'Cancelado'