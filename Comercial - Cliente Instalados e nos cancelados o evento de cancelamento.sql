WITH ranked_events AS (
    SELECT 
        ce.contract_id,
        cet.title AS event_title,
        ce.contract_event_type_id,
        ROW_NUMBER() OVER (
            PARTITION BY ce.contract_id 
            ORDER BY ce.id DESC
        ) AS rn
    FROM contract_events AS ce
    JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
)

SELECT DISTINCT ON (c.id)
    p.name AS cliente,
    p.neighborhood AS bairro,
    p.city AS cidade,
    CASE 
        WHEN c.seller_1_id IS NULL THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = c.created_by) 
        ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) 
    END AS vendedor_1,
    CASE 
        WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' 
        ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) 
    END AS equipe,
    c.v_status AS status_contrato,
    CASE 
        WHEN c.v_status = 'Cancelado' THEN (
            SELECT re.event_title 
            FROM ranked_events AS re 
            WHERE re.contract_id = c.id 
              AND re.rn = 2
        )
        ELSE NULL
    END AS evento_cancelamento
FROM 
    contracts AS c 
    JOIN people AS p ON p.id = c.client_id
    JOIN assignments AS a ON a.requestor_id = p.id 
    JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
    LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
    LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
    LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
    LEFT JOIN contract_events AS ce ON ce.contract_id = c.id
    LEFT JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
WHERE 
    (c.v_stage IN ('Em Aprovação', 'Pré-Contrato') 
    AND c.deleted = FALSE 
    AND ppg.people_group_id IS NOT NULL
    AND c.company_place_id != 3
    AND c.id IN (
        SELECT c.id
        FROM contracts AS c 
        JOIN people AS p ON p.id = c.client_id
        JOIN assignments AS a ON a.requestor_id = p.id
        JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
        WHERE 
            ai.incident_status_id = 4 
            AND ai.incident_type_id IN (1005, 1006, 1901, 1899, 1900)
            AND DATE(a.conclusion_date) >= DATE(c.created)
            AND DATE(a.conclusion_date) BETWEEN '$abertura01' AND '$abertura02'
    )
    AND ai.incident_status_id = 4 
    AND ai.incident_type_id IN (1005, 1006, 1901, 1899, 1900)
    AND DATE(a.conclusion_date) >= DATE(c.created)
    AND DATE(a.conclusion_date) BETWEEN '$abertura01' AND '$abertura02'
    AND c.seller_1_id NOT IN (188, 129, 51))
OR
    (caa.activation_date BETWEEN '$abertura01' AND '$abertura02'
    AND c.seller_1_id NOT IN (188, 129, 51) 
    AND c.company_place_id != 3)
