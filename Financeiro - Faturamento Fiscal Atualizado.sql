SELECT
    --date(notas.issue_date)                 AS emissao,
    issue_date,
    p.id                                    AS cod_pessoa,
    notas.client_name                       AS cliente,
    tx.name                                 AS tipo_cliente,
    p.city                                  AS cidade,
    p.neighborhood                          AS bairro,
    fat.expiration_date                     AS vencimento,
    notas.sale_request_id                   AS pedido_venda,
    date(srp.expiration)                    AS venc_pedido,
    notas.billing_competence                AS competencia,
    notas.document_number                   AS nota_fiscal,
    notas.rps_number                        AS numero_rps,
    CASE WHEN notas.status IN (3,9,10) THEN 'Sim' ELSE 'Nao' END AS nota_cancelada,
    date(notas.cancellation_date)           AS data_cancelamento_nota,
    notas.cancellation_motive               AS motivo_cancelamento,
    notas.total_amount_gross                AS valor_bruto,
    notas.total_amount_liquid               AS valor_liquido,
    notas.discounts                         AS descontos,
    notas.additions                         AS acrescimos,
    notas.issqn_amount                      AS issqn,
    notas.pis_amount                        AS pis,
    notas.cofins_amount                     AS cofins,
    notas.csll_amount                       AS csll,
    notas.irrf_amount                       AS irrf,
    notas.inss_amount                       AS inss,
    notas.icms_amount                       AS icms,
    notas.base_icms_amount                  AS bc_icms,
    cp.description                          AS local_nota,
    ct.title                                AS tipo_contrato,
    fccc.title                              AS tipo_cobranca_contrato,
    fo.title                                AS operacao,
    nf.title                                AS natureza_financeira,
    invs.title                              AS serie,
    fct_nota.title                          AS tipo_cobranca_nota,
    fct_titulo.title                        AS tipo_cobranca_titulo,
    c.amount                                AS valor_contrato,
    c.v_status                              AS status_contrato,
    vu.name                                 AS usuario_criador_nota,
    CASE WHEN notas.issqn_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS issqn_retido,
    CASE WHEN p.csll_deducted = 0 THEN 'Não' WHEN p.csll_deducted = 2 THEN 'Sim' ELSE 'Normal' END AS pis_retido,
    CASE WHEN p.csll_deducted = 0 THEN 'Não' WHEN p.csll_deducted = 2 THEN 'Sim' ELSE 'Normal' END AS cofins_retido,
    CASE WHEN notas.csll_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS csll_retido,
    CASE WHEN notas.irrf_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS irrf_retido,
    CASE WHEN notas.inss_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS inss_retido
FROM invoice_notes AS notas
INNER JOIN people AS p               ON p.id = notas.client_id
LEFT JOIN tx_types AS tx             ON tx.id = p.type_tx_id
LEFT JOIN contracts AS c             ON c.id = notas.contract_id
LEFT JOIN contract_types AS ct       ON ct.id = c.contract_type_id
LEFT JOIN financial_collection_types AS fccc ON fccc.id = c.financial_collection_type_id
LEFT JOIN companies_places AS cp     ON cp.id = notas.company_place_id
LEFT JOIN financial_operations AS fo ON fo.id = notas.financial_operation_id
LEFT JOIN financers_natures AS nf    ON nf.id = notas.financer_nature_id
LEFT JOIN invoice_series AS invs     ON invs.id = notas.invoice_serie_id
LEFT JOIN financial_collection_types AS fct_nota   ON fct_nota.id = notas.financial_collection_type_id
LEFT JOIN v_users AS vu              ON vu.id = notas.created_by
LEFT JOIN LATERAL (
    SELECT fat.expiration_date, fat.financial_collection_type_id
    FROM financial_receivable_titles AS fat
    WHERE fat.invoice_note_id = notas.id
    ORDER BY fat.expiration_date DESC
    LIMIT 1
) AS fat ON TRUE
LEFT JOIN financial_collection_types AS fct_titulo ON fct_titulo.id = fat.financial_collection_type_id
LEFT JOIN LATERAL (
    SELECT srp.expiration
    FROM sale_request_parcels AS srp
    WHERE srp.sale_request_id = notas.sale_request_id
    ORDER BY srp.expiration DESC
    LIMIT 1
) AS srp ON TRUE
WHERE notas.issue_date >= '2026-07-01'
  AND notas.issue_date <  '2026-07-31'::date + INTERVAL '1 day'
  AND notas.status <> 9  -- Cancelado
  AND notas.document_number IS NOT NULL
  AND notas.financial_operation_id IN (34, 63, 105, 104, 26, 27, 1, 65)
ORDER BY notas.document_number;