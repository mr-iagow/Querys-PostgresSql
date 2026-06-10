SELECT
  ct.id AS id_contrato,
  p.name AS cliente,
  DATE(ct.created) AS data_criacao_contrato,
  DATE(ce.created) AS data_evento_cancelamento,
  (SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS local_contrato,
  ctt."description" AS tipo_contrato,
  ct.amount AS valor_contrato,
  ci."description" AS plano,
  ultimo_recebimento.receipt_date AS data_ultimo_boleto_recebido,
  COALESCE(bloqueio.fatura_bloqueio, fatura_aberta.title) AS fatura_bloqueio,
  COALESCE(frt_bloqueio.title_amount, fatura_aberta.title_amount) AS valor_fatura_bloqueio,
  COALESCE(frt_bloqueio.expiration_date, fatura_aberta.expiration_date) AS vencimento_fatura_bloqueio

FROM contracts AS ct
LEFT JOIN contract_events AS ce ON ce.contract_id = ct.id
LEFT JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN people AS p ON p.id = ct.client_id
LEFT JOIN contract_items AS ci ON ci.contract_id = ct.id AND ci.p_is_billable = TRUE
LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id AND sp.id NOT IN (3591,3801,3592,6199,5525,5526,6200,3802,5527,5528,2761,6169,6170,2762,6366,6367,45,6327,6092,6602)
LEFT JOIN contract_types AS ctt ON ctt.id = ct.contract_type_id
LEFT JOIN LATERAL (
  SELECT 
    (regexp_match(ev.description, 'Nº (FAT[^\s.]+)'))[1] AS fatura_bloqueio
  FROM contract_events ev
  WHERE ev.contract_id = ct.id
    AND ev.description ILIKE '%bloqueado por possuir títulos%'
  ORDER BY ev.created DESC
  LIMIT 1
) AS bloqueio ON TRUE
LEFT JOIN LATERAL (
  SELECT 
    title,
    title_amount,
    expiration_date
  FROM financial_receivable_titles
  WHERE title = bloqueio.fatura_bloqueio
  ORDER BY expiration_date DESC
  LIMIT 1
) AS frt_bloqueio ON TRUE
-- Fatura mais antiga em aberto (fallback quando não tem evento de bloqueio)
-- Fatura mais antiga em aberto (fallback quando não tem evento de bloqueio)
LEFT JOIN LATERAL (
  SELECT
    frt.title,
    frt.title_amount,
    frt.expiration_date
  FROM financial_receivable_titles frt
  WHERE frt.client_id = ct.client_id
    AND frt.title LIKE '%FAT%'
    AND frt.p_is_receivable = TRUE
  ORDER BY frt.expiration_date ASC
  LIMIT 1
) AS fatura_aberta ON TRUE
LEFT JOIN LATERAL (
  SELECT
    frtt.receipt_date
  FROM financial_receipt_titles frtt
  WHERE frtt.client_id = ct.client_id
  ORDER BY frtt.receipt_date DESC
  LIMIT 1
) AS ultimo_recebimento ON TRUE
WHERE
  DATE(ce.created) BETWEEN '2026-01-01' AND '2026-05-30'
  AND cet.id = 184
  AND ct.contract_type_id IN (35,36,37,38,39,45)
ORDER BY ct.id, ce.created