SELECT 

p.name AS cliente,
cp.code  lc,
frt.title AS titulo,
frt.id AS iu,
frt.bank_title_number AS nosso_numero,
frt.expiration_date AS vencimento,
frt.document_amount AS valor_titulo,
frt.balance AS saldo,
frt.entry_date AS emissao,
cp.description AS local_fatura,
fn.title AS natureza_financeira,
fct.title AS tipo_cobranca,
frt.expiration_date AS vencimento,
frt.original_expiration_date AS vencimento_original,
CASE 
	WHEN frtt.receipt_date IS NOT NULL THEN 'Titulo Recebido'
	WHEN frtt.receipt_date IS NULL THEN 'Em Aberto'
END AS status_pagamento,
frtt.receipt_date AS data_recebimento,
ba.description AS conta


FROM financial_receivable_titles AS frt
LEFT JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
JOIN people AS p ON p.id = frt.client_id
JOIN companies_places AS cp ON cp.id = frt.company_place_id
JOIN financers_natures AS fn ON fn.id = frt.financer_nature_id
left JOIN financial_collection_types AS fct ON fct.id = frt.financial_collection_type_id 
JOIN bank_accounts AS ba ON ba.id = frt.bank_account_id


WHERE 

frt.title LIKE '%FAT%'
AND frt.expiration_date BETWEEN '2025-01-03' AND '2025-01-03'