SELECT DISTINCT ON (fatr.id)
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.name AS nome,
p.neighborhood AS bairro,
p.city AS cidade,
fat.title AS fatura,
(SELECT nf.title FROM financers_natures AS nf WHERE fat.financer_nature_id = nf.id) AS natureza_financeira,
fat.expiration_date AS vencimento,
DATE_FORMAT(fat.competence, '%m-%Y') AS competencia,
CASE WHEN fatr.finished = TRUE THEN 'SIM' WHEN fatr.finished = FALSE THEN 'NAO' END AS baixado,
fatr.amount AS valor_original,
fatr.fine_amount AS multa,
fatr.increase_amount AS juros,
fatr.discount_value AS desconto,
SUM((fatr.amount + fatr.fine_amount + fatr.increase_amount) - fatr.discount_value) AS total_recebido,
fatr.bank_tax_amount AS tarifa_bancaria,
fin.amount AS tarifa_bancaria_finee,
fatr.credit_card_tax AS taxa_cartao,
fatr.receipt_date AS data_recebimento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = fatr.created_by) AS usuario_responsavel,
(SELECT comp.description FROM companies_places AS comp WHERE fat.company_place_id = comp.id) AS local_fatura,
(SELECT comp.description FROM companies_places AS comp WHERE fatr.company_place_id = comp.id) AS local_recebimento,
(SELECT pf.title FROM payment_forms AS pf WHERE pf.id = fatr.payment_form_id) AS forma_pagamento,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = fat.financial_operation_id) AS operacao_titulo, 
c.amount AS valor_contrato,
(SELECT bacc.description FROM bank_accounts AS bacc  WHERE fatr.bank_account_id = bacc.id ) AS conta_liquidacao

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
LEFT JOIN financial_integrations_fees AS fin ON fin.financial_receivable_title_id = fat.id
INNER JOIN people AS p ON fatr.client_id = p.id
LEFT JOIN contracts AS c ON fat.contract_id = c.id

WHERE fatr.receipt_date BETWEEN '2024-04-15' AND '2024-04-15'
AND fat.title LIKE '%FAT%'

OR fatr.receipt_date BETWEEN '2024-04-15' AND '2024-04-15'
AND fat.origin IN (3,4,7,11) AND fatr.receipt_origin_id IS NULL

GROUP BY fatr.id,tipo_cliente, nome, bairro, cidade, fatura, natureza_financeira, vencimento, competencia, baixado, 
data_recebimento, valor_original, multa, juros, tarifa_bancaria, fin.amount, desconto, usuario_responsavel, local_fatura,
forma_pagamento, operacao_contrato, valor_contrato,fat.financial_operation_id