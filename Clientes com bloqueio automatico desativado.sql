SELECT DISTINCT ON (frt.id)
    p.name AS nome_cliente,
    (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) AS motivo_nao_bloqueio,
    frt.title_amount AS valor_em_aberto,
    (SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
    frt.expiration_date AS data_vencimento_fatura,
    frt.title AS fatura,
    CURRENT_DATE - frt.expiration_date AS dias,
    c.v_status AS status_contrato
    
FROM
    authentication_contracts AS ac
    JOIN contracts AS c ON c.id = ac.contract_id
    JOIN financial_receivable_titles AS frt ON frt.contract_id = c.id
    JOIN people AS p ON p.id = c.client_id
    LEFT JOIN contract_event_types AS cet ON cet.id = c.contract_event_id
    LEFT join person_people_groups AS ppg ON ppg.person_id = p.id
    
WHERE 
    c.contract_type_id NOT IN (6,10,11,7,4)
    AND frt.p_is_receivable = TRUE
    AND c.automatic_blocking = FALSE 
    AND c.id NOT IN (22188)
    AND ppg.people_group_id <> 22
