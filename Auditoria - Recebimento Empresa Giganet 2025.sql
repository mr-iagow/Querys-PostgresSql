SELECT
  tt.name AS tipo_cliente,
  pe."name" AS nome,
  pe.neighborhood AS bairro,
  pe.city AS cidade,
  fat.title AS fatura,
  fn.title AS natureza_financeira,
  fat.expiration_date AS vencimento,
  TO_CHAR(fat.competence, 'MM-YYYY') AS competencia,
  CASE WHEN fatr.finished = TRUE THEN 'SIM' ELSE 'NAO' END AS baixado,
  fatr.amount AS valor_original,
  fatr.fine_amount AS multa,
  fatr.increase_amount AS juros,
  fatr.discount_value AS desconto,
  ((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido,
  fatr.bank_tax_amount AS tarifa_bancaria,
  fin.amount AS tarifa_bancaria_finee,
  fatr.credit_card_tax AS taxa_cartao,
  fatr.receipt_date AS data_recebimento,
  vu.name AS usuario_responsavel,
  ct.title AS tipo_contrato,
  fccc.title AS tipo_cobranca_contrato,
  comp_fat.description AS local_fatura,
  comp_rec.description AS local_recebimento,
  pf.title AS forma_pagamento,
  fo_contrato.title AS operacao_contrato,
  fo_titulo.title AS operacao_titulo,
  c.amount AS valor_contrato,
  bacc.description AS conta_liquidacao,
  fatr.complement AS complemento
FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
-- JOIN para detectar se existe um par FAT% para o mesmo cliente+contrato+competência
LEFT JOIN financial_receivable_titles AS fat_fat
  ON fat_fat.client_id = fat.client_id
  AND fat_fat.contract_id = fat.contract_id
  AND fat_fat.competence = fat.competence
  AND fat_fat.title LIKE 'FAT%'
  AND fat_fat.id != fat.id
LEFT JOIN financial_integrations_fees AS fin ON fin.financial_receivable_title_id = fat.id
LEFT JOIN contracts AS c ON c.id = fat.contract_id
LEFT JOIN contract_types AS ct ON ct.id = c.contract_type_id
LEFT JOIN financial_collection_types AS fccc ON fccc.id = c.financial_collection_type_id
LEFT JOIN people AS pe ON pe.id = fat.client_id
LEFT JOIN tx_types AS tt ON tt.id = pe.type_tx_id
LEFT JOIN financers_natures AS fn ON fat.financer_nature_id = fn.id
LEFT JOIN v_users AS vu ON vu.id = fatr.created_by
LEFT JOIN companies_places AS comp_fat ON fat.company_place_id = comp_fat.id
LEFT JOIN companies_places AS comp_rec ON fatr.company_place_id = comp_rec.id
LEFT JOIN payment_forms AS pf ON pf.id = fatr.payment_form_id
LEFT JOIN financial_operations AS fo_contrato ON fo_contrato.id = c.operation_id
LEFT JOIN financial_operations AS fo_titulo ON fo_titulo.id = fat.financial_operation_id
LEFT JOIN bank_accounts AS bacc ON fatr.bank_account_id = bacc.id
WHERE fatr.receipt_date BETWEEN '2025-01-01' AND '2025-12-31'
  AND fatr.deleted = FALSE
  --AND pe."name" = 'MARIA APARECIDA LOPES DOS SANTOS'
  AND (
    c.contract_type_id IN (35, 36, 37, 38, 39, 45)
    OR (
      fat.company_place_id IN (14)
      AND fat.origin IN (1, 3, 4, 7, 11, 44, 8)
      AND fatr.receipt_origin_id IS NULL
    )
  )
  --OR (fat.id = 7763298) Essa fat da diferenda de 50 reais do relatório para o sistema
  -- descarta o sem FAT% só quando existe um par FAT% para o mesmo grupo
  AND NOT (fat.title NOT LIKE 'FAT%' AND fat_fat.id IS NOT NULL)
ORDER BY fat.client_id, fat.contract_id, fat.competence, fatr.receipt_date