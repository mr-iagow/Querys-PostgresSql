SELECT 
    p.id AS cod_cliente,
    p.name AS cliente,
    (SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS local_contrato,
    (SELECT c.title FROM contract_types AS c WHERE c.id = ct.contract_type_id) AS tipo_contrato,
    ct.v_stage AS estagio_contrato,
    ct.v_status AS status_contrato,
    ct.amount AS Valor_contrato,
    aap.title AS condominio,
    CASE 
        WHEN aap.title LIKE 'SHOPPING%' THEN 'SHOPPING'
        ELSE 'CONDOMINIO'
    END AS tipo,
    CASE 
        WHEN ct.seller_1_id IS NULL THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = ct.created_by)
        ELSE (SELECT p.name FROM people AS p WHERE p.id = ct.seller_1_id)
    END AS vendedor_1,
    CASE 
        WHEN ppg.people_group_id IS NULL THEN 'Sem equipe' 
        ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id)
    END AS equipe
FROM contracts AS ct
JOIN authentication_contracts AS ac ON ac.contract_id = ct.id
JOIN people AS p ON p.id = ct.client_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = ct.seller_1_id
LEFT JOIN authentication_access_points AS aap ON aap.id = ac.condominium_id
WHERE ac.condominium_id IS NOT NULL;
