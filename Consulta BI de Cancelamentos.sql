SELECT DISTINCT
    c.id AS cod_contrato,
    p.name AS nome_cliente,
    c.amount AS valor_mensalidade,
    c.v_status AS status_contrato,
    CASE WHEN ce.created = '0001-01-01 00:00:00' THEN date(ce.date) ELSE date(ce.created) END AS data_cancelamento,
    cat.activation_date AS data_ativacao,
    CASE WHEN ce.created = '0001-01-01 00:00:00' THEN date(ce.date) ELSE date(ce.created) END - cat.activation_date AS cancelamento_ativacao,
    CASE WHEN cet.id IN (184,214) THEN 'Involuntario' ELSE 'Voluntário' END AS tipo_cancelamento,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
    p.city AS cidade_cliente,
    p.neighborhood AS bairro,
    (SELECT cet.title FROM contract_event_types AS cet WHERE cet.id = ce.contract_event_type_id) AS motivo_cancelamento,
    COALESCE(
        CASE WHEN c.seller_1_id IS NULL THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = cpo.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) END,
        'SEM VENDEDOR'
    ) AS vendedor,
    COALESCE(
        CASE WHEN c.seller_1_id IS NULL THEN (SELECT pg.title FROM people_groups AS pg WHERE pg.id = (SELECT ppg.people_group_id FROM person_people_groups AS ppg WHERE ppg.person_id = cpo.proprietary_id))
        ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END,
        'SEM EQUIPE'
    ) AS equipe
FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN contract_assignment_activations AS cat ON cat.contract_id = c.id
LEFT JOIN crm_person_oportunities AS cpo ON cpo.contact_id = c.id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
WHERE c.company_place_id != 3 
    AND (
        date(ce.created) BETWEEN cast(date_trunc('month', current_date - INTERVAL '11 month') AS date) AND DATE(curdate())
        AND ce.contract_event_type_id IN (110,154,156,157,158,159,163,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,190,192,195,196,197,198,199,200,201,202,203,225,226)
        OR DATE(ce.date) BETWEEN cast(date_trunc('month', current_date - INTERVAL '11 month') AS date) AND DATE(curdate())
        AND ce.contract_event_type_id = 214
    );