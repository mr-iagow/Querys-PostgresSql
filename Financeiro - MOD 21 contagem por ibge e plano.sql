SELECT 
    CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' WHEN p.type_tx_id != 1 THEN 'CPF' END AS tipo_cliente,
    edr.code_city_id AS cod_ibge,
    n.billing_competence AS competencia,
    EXTRACT(YEAR FROM n.billing_competence) AS ano,
    EXTRACT(MONTH FROM n.billing_competence) AS mes,
    n.company_place_name AS LOCAL,
    sp.huawei_profile_name AS plano_policy,
    sp.title AS plano,
    COUNT(DISTINCT n.id) AS contagem_plano_ibge
FROM 
    invoice_notes AS n
LEFT JOIN 
    authentication_contracts AS c ON n.contract_id = c.contract_id
LEFT JOIN 
    service_products AS s ON c.service_product_id = s.id
LEFT JOIN 
    contract_items AS ci ON n.contract_id = ci.contract_id
INNER JOIN 
    people AS p ON n.client_id = p.id
LEFT JOIN 
    contracts AS cont ON n.contract_id = cont.id
LEFT JOIN
    people_addresses AS edr ON cont.people_address_id = edr.id
INNER JOIN
    invoice_note_items AS ini ON ini.invoice_note_id = n.id
LEFT JOIN 
    service_products AS sp ON sp.id = ini.service_product_id
WHERE 
    n.movement_date BETWEEN '2024-05-01' AND '2024-05-31'
    AND n.status = 1
    --AND edr.code_city_id = 2302909
    AND n.company_place_id IN (10,9,3,7,2,4)
    AND n.invoice_serie_id IN (1,104,108,113,126,127,128,170,171,175)
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
ORDER BY cod_ibge, tipo_cliente;
