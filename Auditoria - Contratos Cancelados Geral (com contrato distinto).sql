WITH params AS (
  SELECT DATE '2026-09-01' AS inicio, DATE '2026-09-30' AS fim
),
eventos AS (
  SELECT DISTINCT ON (e.contract_id)
    e.contract_id,
    e."date"                                         AS data_evento,
    t.code                                           AS evento_codigo,
    t.title                                          AS evento_titulo,
    COUNT(*) OVER (PARTITION BY e.contract_id)       AS qtd_cancelamentos_periodo
  FROM params
  JOIN erp.contract_events AS e
    ON e.contract_event_type_id = ANY (ARRAY(
         SELECT t2.id FROM erp.contract_event_types AS t2 WHERE t2.title ILIKE '%cancelam%'
       ))
   AND e."date" >= params.inicio
   AND e."date" <  params.fim + 1
   AND e.deleted = FALSE
  JOIN erp.contract_event_types AS t ON t.id = e.contract_event_type_id
  ORDER BY e.contract_id, e."date" DESC, e.id DESC
)
SELECT
  c.id                                              AS id_contrato,
  c.contract_number                                 AS numero_contrato,
  tx.name                                          AS tipo_cliente,
  p."name"                                          AS cliente,
  CASE WHEN inad.cliente_id IS NOT NULL THEN 'Inadimplente' ELSE 'Adimplente' END AS status_cliente,
  inad.valor_aberto                                 AS valor_em_aberto,
  to_char(c."date", 'DD/MM/YYYY')                   AS data_cricao_contrato,
  to_char(COALESCE(ativ.data, c.created::date), 'DD/MM/YYYY') AS data_ativacao_contrato,
  to_char(ev.data_evento, 'DD/MM/YYYY')             AS data_cancelamento,
  to_char(c.cancellation_date, 'DD/MM/YYYY')        AS data_cancelamento_atual_contrato,
  ev.evento_codigo                                  AS evento_codigo,
  ev.evento_titulo                                  AS evento_cancelamento,
  ev.qtd_cancelamentos_periodo                      AS qtd_cancelamentos_periodo,
  vend."name"                                       AS vendedor, 
  CASE
    WHEN c.seller_1_id IS NULL THEN 'Sem vendedor'
    ELSE COALESCE(eq.grupos, 'Sem equipe vinculada')
  END                                               AS equipe_venda,
  cp.description                                    AS empresa,
  ct.title                                          AS tipo_contrato,
  c.v_status                                        AS status_contrato,
  c.amount                                          AS valor_contrato
FROM eventos AS ev
JOIN erp.contracts AS c              ON c.id = ev.contract_id
JOIN erp.people AS p                 ON p.id = c.client_id
LEFT JOIN erp.client_types AS cty    ON cty.id = c.client_type
LEFT JOIN erp.contract_types AS ct   ON ct.id = c.contract_type_id
LEFT JOIN erp.companies_places AS cp ON cp.id = c.company_place_id
LEFT JOIN erp.people AS vend         ON vend.id = c.seller_1_id
LEFT JOIN erp.tx_types AS tx         ON tx.id = p.type_tx_id
LEFT JOIN LATERAL (
  SELECT MAX(caa.activation_date)::date AS data
  FROM erp.contract_assignment_activations AS caa
  WHERE caa.contract_id = c.id AND caa.deleted = FALSE
) AS ativ ON TRUE

LEFT JOIN LATERAL (
  SELECT string_agg(pg.title, ' / ' ORDER BY pg.title) AS grupos
  FROM erp.person_people_groups AS ppg
  JOIN erp.people_groups AS pg ON pg.id = ppg.people_group_id AND pg.deleted = FALSE
  WHERE ppg.person_id = c.seller_1_id
) AS eq ON TRUE

LEFT JOIN LATERAL (
  SELECT f.client_id AS cliente_id, SUM(f.balance) AS valor_aberto
  FROM erp.financial_receivable_titles AS f
  WHERE f.client_id = c.client_id
    AND f.type = 2
    AND f.deleted = FALSE
    AND f.finished = FALSE
    AND f.renegotiated = FALSE
    AND f.bill_title_id IS NULL
    AND f.balance > 0
    AND f.expiration_date < CURRENT_DATE
  GROUP BY f.client_id
) AS inad ON TRUE
ORDER BY ev.data_evento, c.id;
