SELECT DISTINCT ON (frt.financial_receivable_title_id)

(SELECT p.name FROM people AS p WHERE p.id = frt2.client_id) AS cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = frt2.company_place_id) AS empresa,
(SELECT bacc.description FROM bank_accounts AS bacc  WHERE frt.bank_account_id = bacc.id ) AS conta_liquidacao,
DATE (frt2.created) AS data_emissao,
DATE (frt2.expiration_date) AS vencimento,
DATE (frt2.original_expiration_date) AS vencimento_original,
DATE (frt.receipt_date) AS recebimento,
frt.increase_amount AS acrescimo,
frt.discount_value AS desconto,
fin.amount AS tarifa_bancaria,
frt.other_credits AS outros_creditos,
frt.other_debts AS outros_debitos,
frt.fine_amount + frt.amount + frt.increase_amount AS valor,
frt2.title AS titulo,
frt2.parcel AS parcela,
inv.document_number AS numero_documento,
frt2.bank_title_number AS nn,
(SELECT nf.title FROM financers_natures AS nf WHERE frt2.financer_nature_id = nf.id) AS natureza_financeira,
frt2.complement AS complemento,
(SELECT pf.title FROM payment_forms AS pf WHERE pf.id = frt.payment_form_id) AS forma_pagamento

FROM  financial_receipt_titles AS frt 
JOIN financial_receivable_titles AS frt2 ON frt2.id = frt.financial_receivable_title_id
LEFT JOIN financial_integrations_fees AS fin ON fin.financial_receivable_title_id = frt2.id
LEFT JOIN invoice_notes AS inv ON inv.id = frt2.invoice_note_id

WHERE

DATE (frt.receipt_date)  BETWEEN '$recebimento01' AND '$recebimento02'
AND frt.company_place_id = 1
AND frt2.title LIKE '%FAT%'