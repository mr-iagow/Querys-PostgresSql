WITH evento_assinatura AS (
    SELECT 
        ce.contract_id AS id_contrato,
        cet.title AS evento_assinatura,
        ce.created AS data_criacao_evento,
        ce."description" AS descricao_evento
    FROM contract_events AS ce
    JOIN contract_event_types AS cet 
        ON cet.id = ce.contract_event_type_id 
        AND cet.id = 150
)
SELECT 
    p.name AS cliente,
    ct.contract_number AS numero_contrato,
    pl.plano,
    pl.valor_plano,
    p2.name AS vendedor_1,
    cp.description AS empresa,
    ctr.title AS tipo_contrato,
    ct.collection_day AS vencimento,
    CASE 
      WHEN ct.discount_use_contract = 1 THEN 'Conforme Contrato'
      WHEN ct.discount_use_contract = 0 THEN 'Conforme Tipo De Cobrança'
      WHEN ct.discount_use_contract = 2 THEN 'Não Aplica Desconto'
    END AS possui_desconto_no_contrato,
    ct.discount_value AS valor_desconto,
    ea.evento_assinatura,
    ea.data_criacao_evento,
    ea.descricao_evento,
    p.email,
    p."email_NFE",
    pa.neighborhood AS bairro,
    pa.city AS cidade,
    CASE
        WHEN p.csll_deducted = 0 THEN 'Sem Retenção'
        WHEN p.csll_deducted = 1 THEN 'Normal'
        WHEN p.csll_deducted = 2 THEN 'Reter Sempre'
    END AS pis_cofins_csll,
    CASE
        WHEN p.retains_income_tax = 0 THEN 'Sem Retenção'
        WHEN p.retains_income_tax = 2 THEN 'Normal'
        WHEN p.retains_income_tax = 1 THEN 'Reter Sempre'
    END AS retem_ir,
    CASE 
        WHEN p.taxes_municipality = 1 THEN 'Sim'
        WHEN p.taxes_municipality = 2 THEN 'Não'
    END AS tributa_no_municipio,
    CASE 
        WHEN p.taxes_issqn = TRUE THEN 'Sim'
        WHEN p.taxes_issqn = FALSE THEN 'Não'
    END AS tributa_issqn,
    CASE 
        WHEN p.resp_retains = TRUE THEN 'Sim'
        WHEN p.resp_retains = FALSE THEN 'Não'
    END AS prestado_responsavel_retencao,
    CASE 
        WHEN p.state_registration_type = 2 THEN 'Isento'
        WHEN p.state_registration_type = 1 THEN 'Contribuinte'
        WHEN p.state_registration_type = 9 THEN 'Nao Contribuinte'
    END AS tipo_insc_estadual,
    p.state_registration AS insc_estadual,
    p.tax_percentage AS aliquota_issqn,
    ai.protocol AS protocolo_ativacao,
    ins.title AS status_solicitacao,
    a.description AS relato_abetura_ativacao,
    a.report_closing_date AS data_encerramento,
    p3.name AS usuario_responsavel_ativacao,
    ur.relato_encerramento,
    ac.user AS pppoe
FROM contracts AS ct
JOIN contract_service_tags AS ctag ON ctag.contract_id = ct.id
JOIN assignments AS a ON a.requestor_id = ct.client_id
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id AND ai.incident_status_id = 4
JOIN incident_types AS it ON it.id = ai.incident_type_id AND it.activation_type = TRUE 
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
JOIN people AS p ON p.id = ai.client_id
JOIN companies_places AS cp ON cp.id = ct.company_place_id
JOIN contract_types AS ctr ON ctr.id = ct.contract_type_id
LEFT JOIN people_addresses AS pa ON pa.id = ct.people_address_id AND pa.deleted = FALSE 
LEFT JOIN people AS p2 ON p2.id = ct.seller_1_id
LEFT JOIN evento_assinatura AS ea ON ea.id_contrato = ct.id
JOIN people AS p3 ON p3.id = a.responsible_id
LEFT JOIN LATERAL (
    SELECT r.description AS relato_encerramento
    FROM reports AS r
    WHERE r.assignment_id = a.id
    ORDER BY r.created DESC
    LIMIT 1
) AS ur ON TRUE
LEFT JOIN LATERAL (
    SELECT 
        COALESCE(
            STRING_AGG(sp.title, ', ' ORDER BY sp.title) FILTER (WHERE ci.is_composition = 'true'),
            STRING_AGG(sp.title, ', ' ORDER BY sp.title) FILTER (WHERE ci.is_composition = 'false')
        ) AS plano,
        COALESCE(
            SUM(ci.total_amount) FILTER (WHERE ci.is_composition = 'true'),
            SUM(ci.total_amount) FILTER (WHERE ci.is_composition = 'false')
        ) AS valor_plano
    FROM contract_items AS ci
    JOIN service_products AS sp ON sp.id = ci.service_product_id
    WHERE ci.contract_id = ct.id
      AND ci.deleted = FALSE
) AS pl ON TRUE
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = ct.id

WHERE ct.stage IN (1, 4)
AND ct.deleted = FALSE
AND ct.v_status != 'Cancelado'
AND a.created >= ct.created