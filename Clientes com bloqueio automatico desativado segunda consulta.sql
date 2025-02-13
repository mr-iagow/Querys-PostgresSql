SELECT DISTINCT ON (c.id)
    c.id,
    p.name AS nome_cliente,
    ce.description AS evento,
    MAX(DATE(ce.created)) AS data_evento,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
    (SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
    v.name AS usuario_responsavel,
    (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) AS motivo_nao_bloqueio,
    (SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato,
    c.v_status AS status_contrato
    
FROM contracts AS c
JOIN contract_events AS ce ON ce.contract_id = c.id 
JOIN people AS p ON p.id = c.client_id
LEFT JOIN v_users AS v ON v.id = ce.created_by
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = p.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id

WHERE ce.description LIKE '%Bloqueio automático alterado de "Ativo" para "Inativo"%'
    AND c.automatic_blocking = false
    AND c.contract_type_id NOT IN (6, 10, 11, 7, 4)
    AND c.v_status != 'Cancelado'
    AND c.id NOT IN (22188)
    AND ppg.people_group_id <> 22
    
GROUP BY c.id, p.name, ce.description, c.company_place_id, ppg.people_group_id, c.contract_type_id, v.name, c.v_status,ac.service_product_id
ORDER BY c.id, MAX(DATE(ce.created)) DESC;
