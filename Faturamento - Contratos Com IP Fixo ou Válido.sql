SELECT
p.name AS Cliente,
c.contract_number AS numero_contrato,
CASE WHEN sp.title IS NULL THEN 'SEM SERVICO IP VINCULADO' ELSE 'SERVICO VINCULADO' END AS possui_servico_ip_contrato,
CASE 
    WHEN sp.title IS NOT NULL 
        THEN to_char(ci.total_amount, 'FM999999990D00')
    ELSE 'SEM SERVICO IP VINCULADO'
END AS valor_servico_ip_contrato,
p.city AS cidade,
c.beginning_date AS data_inicio,
ac.user AS PPPOE,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS Plano,
c.amount AS valor,
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS Ponto_de_Acesso,
(SELECT acp.title FROM authentication_concentrators AS acp WHERE acp.id = ac.authentication_concentrator_id) AS concentrador,
aip.ip AS IP,
CASE WHEN ac.ip_type = 1 THEN 'IP Fixo' WHEN ac.ip_type != 1 THEN 'Pelo CE' END AS tipo_IP,
c.v_status AS status_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato


FROM people AS p
INNER JOIN contracts AS c ON c.client_id = p.id
INNER JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN authentication_ips AS aip ON aip.id = ac.ip_authentication_id
LEFT JOIN contract_items AS ci ON ci.contract_id = c.id AND ci.deleted = FALSE AND ci.service_product_id IN (45,6327,7675,8947)
LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id

WHERE ac.ip_type = 1 --AND c.id = 109544 
--AND c.contract_number = '0021546' --AND ac.authentication_concentrator_id IN (2,7)