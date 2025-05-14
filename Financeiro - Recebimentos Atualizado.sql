SELECT DISTINCT ON (fatr.id)
tt.name AS tipo_cliente,
COALESCE(notas.client_name, pe.name) AS nome,
COALESCE(notas.client_neighborhood, pe.neighborhood) AS bairro,
COALESCE(notas.client_city, pe.city) AS cidade,
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
comp_fat.description AS local_fatura,
comp_rec.description AS local_recebimento,
pf.title AS forma_pagamento,
fo_contrato.title AS operacao_contrato,
fo_titulo.title AS operacao_titulo,
c.amount AS valor_contrato,
bacc.description AS conta_liquidacao

FROM financial_receivable_titles AS fat
INNER JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id
LEFT JOIN financial_integrations_fees AS fin ON fin.financial_receivable_title_id = fat.id
LEFT JOIN contracts AS c ON c.id = fat.contract_id
LEFT JOIN invoice_notes AS notas ON notas.id = fat.invoice_note_id
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

WHERE fatr.receipt_date BETWEEN '2025-04-01' AND '2025-04-30'
AND fatr.deleted = FALSE
AND ( 
		fat.title LIKE '%FAT%' 
		OR 
		(fat.origin IN (1, 3, 4, 7, 11) AND fatr.receipt_origin_id IS NULL)
	)

GROUP BY fatr.id,tipo_cliente, nome, bairro, cidade, fatura, natureza_financeira, vencimento, competencia, baixado, 
data_recebimento, valor_original, multa, juros, tarifa_bancaria, tarifa_bancaria_finee, desconto, usuario_responsavel, local_fatura,
forma_pagamento, operacao_contrato, valor_contrato, local_recebimento, operacao_titulo, conta_liquidacao