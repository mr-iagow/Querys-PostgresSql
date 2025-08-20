SELECT 

frt.title AS titulo,
p."name" AS cliente,
frto.created AS data_evento_recebimento, 
frtt.receipt_date AS data_recebimento_sistema,
cp."description" AS empresa

FROM financial_receivable_titles AS frt
JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
JOIN financial_receivable_title_occurrences AS frto ON frto.financial_receivable_title_id = frtt.financial_receivable_title_id
LEFT JOIN people AS p ON p.id = frt.client_id
JOIN companies_places AS cp ON cp.id = frtt.company_place_id

WHERE 
frt.title LIKE '%FAT%'
AND frto.financial_title_occurrence_type_id = 26
AND DATE (frto.created) = '2025-08-15'
AND frtt.payment_form_id IN (13,15)
--AND p.id != 41195 removido cliente que teve o recebimento excluido e após feito manualmente