SELECT 
(SELECT p.name FROM people AS p WHERE p.id = frt.client_id) AS cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = frtt.company_place_id) AS LOCAL,
frt.title AS fatura,
frtt.credit_card_authorization_code AS cod_autorizacao,
frtt.credit_card_nsu AS nsu_doc,
frtt.receipt_date AS recebimento_cliente,
frtt.credit_card_prevision_receipt_date AS previsao_pagamento,
frtt.total_amount AS valor,
frtt.credit_card_tax AS taxa,
frtt.credit_card_amount AS valor_liquido,
CASE 
	WHEN frtt.credit_card_status = 1 THEN 'Aguardando Pagamento'
	WHEn frtt.credit_card_status = 2 THEN 'Pago'
END AS situacao

FROM financial_receivable_titles AS frt 
LEFT JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id


WHERE 
DATE (frtt.receipt_date) BETWEEN '2024-04-01' AND '2024-04-30'
AND frtt.payment_form_id = 5
AND frtt.financial_collection_type_id IN (25,26,27,54,55,56,57,58,59,60,61,62,63,64,65,66,74,75,76,77,85,86,87,88)
AND frt.title LIKE '%FAT%'
