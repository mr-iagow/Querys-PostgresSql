SELECT 
(SELECT p.name FROM people AS p WHERE p.id = frt.client_id) AS cliente,
DATE (frt.created) AS emissao,
(SELECT v.name FROM v_users AS v WHERE v.id = frto.created_by) AS responsavel_faturamento,
frt.expiration_date AS vencimento_boleto

FROM financial_receivable_titles AS frt
LEFT JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
JOIN invoice_notes AS inv ON inv.id =  frt.invoice_note_id
LEFT JOIN financial_receivable_title_occurrences AS frto ON frto.financial_receivable_title_id = frt.id


WHERE 
frto.created BETWEEN '2023-12-01' AND '2023-12-31'
AND frt.financial_collection_type_id IN (89,23,19,72,22,18,17,24,20,71)
--AND frt.client_id = 40365
AND frto.description LIKE '%Título criado na geração da fatura%'
--AND frt.client_id = 40365
AND frto.responsible_id IS NOT NULL 