WITH faturas AS (
  SELECT
    t.contract_id,
    MIN(t.expiration_date) AS primeiro_vencimento,
    COUNT(*)               AS qtd_titulos,
    SUM(t.balance)         AS valor_aberto
  FROM erp.contracts AS c
  JOIN erp.financial_receivable_titles AS t ON t.contract_id = c.id
  WHERE c.status = 6            -- Bloqueio Financeiro
    AND c.deleted = FALSE
    AND t.type = 2
    AND t.deleted = FALSE
    AND t.finished = FALSE
    AND t.renegotiated = FALSE
    AND t.bill_title_id IS NULL
    AND t.balance > 0
    AND t.title LIKE '%FAT%'
  GROUP BY t.contract_id
  HAVING MIN(t.expiration_date) <= CURRENT_DATE - CAST(90 AS integer)
)
SELECT
  c.id                                      AS contract_id,
  c.contract_number                         AS numero_contrato,
  p."name"                                  AS cliente,
  regexp_replace(p.tx_id, '\D', '', 'g')    AS cpf_cnpj,
  regexp_replace(cp.tx_id, '\D', '', 'g')   AS empresa_cnpj,
  COALESCE(NULLIF(pa.city, ''), p.city)     AS cidade,
  c.contract_type_id                        AS tipo_contrato_id,
  ct.title                                  AS tipo_contrato,
  c.financer_nature_id                      AS natureza_financeira_id,
  fn.title                                  AS natureza_financeira,
  c.v_status                                AS situacao,
  to_char(f.primeiro_vencimento, 'YYYY-MM-DD') AS primeiro_vencimento,
  CURRENT_DATE - f.primeiro_vencimento      AS dias_atraso,
  f.qtd_titulos                             AS qtd_titulos,
  f.valor_aberto                            AS valor_aberto
FROM faturas AS f
JOIN erp.contracts AS c ON c.id = f.contract_id
JOIN erp.people AS p ON p.id = c.client_id
LEFT JOIN erp.companies_places AS cp ON cp.id = c.company_place_id
LEFT JOIN erp.people_addresses AS pa ON pa.id = c.people_address_id
LEFT JOIN erp.contract_types AS ct ON ct.id = c.contract_type_id
LEFT JOIN erp.financers_natures AS fn ON fn.id = c.financer_nature_id
ORDER BY dias_atraso DESC, c.id
