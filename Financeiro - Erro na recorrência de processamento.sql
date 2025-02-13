SELECT 
p.id AS id_pessoa,
frt2.contract_id AS id_contrato,
p.name AS cliente,
frt2.title AS titulo,
(SELECT pf.title FROM payment_forms AS pf WHERE pf.id = frt.payment_form_id) AS forma_pagamento,
CASE WHEN frt2.balance = 0 THEN 'Pago' ELSE 'Em Aberto' END AS status_pg,
DATE (frt2.created) AS data_emissao,
frt2.expiration_date AS data_vencimento,
frt.receipt_date AS data_recebimento,
frto.description AS erro,
frt.amount AS valor_original,
frt.increase_amount AS juros,
frt.fine_amount AS multa,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = frt.company_place_id) AS local_fatura

FROM financial_receipt_titles AS frt
JOIN people AS p ON p.id = frt.client_id
JOIN financial_receivable_titles AS frt2 ON frt2.id = frt.financial_receivable_title_id
JOIN financial_receivable_title_occurrences AS frto ON frto.financial_receivable_title_id = frt2.id

WHERE 
--p.name = 'LIVIA ANDRADE DE ARAUJO'
frto.financial_title_occurrence_type_id = 80
AND DATE (frto.created) BETWEEN '2022-01-01' AND '2024-02-29'
