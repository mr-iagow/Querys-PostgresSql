SELECT
    c.id                                   AS contrato,
    p.id 											 AS id_cliente,
    p."name" 										 AS cliente,
    c.v_status                             AS status_contrato,
    cp.description                         AS empresa,
    ct.title                               AS tipo_contrato,
    CASE p.csll_deducted
        WHEN 0 THEN 'Sem Retenção'
        WHEN 1 THEN 'Normal'
        WHEN 2 THEN 'Reter Sempre'
    END                                    AS pis_cofins_csll,
    CASE p.retains_income_tax
        WHEN 0 THEN 'Sem Retenção'
        WHEN 2 THEN 'Normal'
        WHEN 1 THEN 'Reter Sempre'
    END                                    AS retem_ir,
    CASE p.taxes_municipality
        WHEN 1 THEN 'Sim'
        WHEN 2 THEN 'Não'
    END                                    AS tributa_no_municipio,
    CASE WHEN p.taxes_issqn  THEN 'Sim' ELSE 'Não' END AS tributa_issqn,
    CASE WHEN p.tax_value    THEN 'Sim' ELSE 'Não' END AS retem_issqn,
    CASE WHEN p.resp_retains THEN 'Sim' ELSE 'Não' END AS prestador_resp_retencao,
    p.tax_percentage                       AS aliquota_issqn,
    p.aliquot_irr                          AS aliquota_irrf,
    p.pis_aliquot                          AS aliquota_pis,
    p.cofins_aliquot                       AS aliquota_cofins
FROM contracts AS c
INNER JOIN people AS p            ON p.id  = c.client_id
LEFT  JOIN companies_places AS cp ON cp.id = c.company_place_id
LEFT  JOIN contract_types AS ct   ON ct.id = c.contract_type_id
WHERE c.v_status NOT IN ('Cancelado', 'Encerrado')
  AND c.deleted = FALSE
ORDER BY c.id;
