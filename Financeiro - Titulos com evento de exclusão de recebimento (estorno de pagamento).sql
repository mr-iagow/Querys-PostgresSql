SELECT DISTINCT ON (frt.id) 

*
FROM financial_receipt_titles AS frt
JOIN financial_receivable_titles AS fat ON fat.id = frt.financial_receivable_title_id
JOIN financial_receivable_title_occurrences AS frto ON frto.financial_receivable_title_id = fat.id

WHERE 
DATE (frto.date) BETWEEN '2024-11-20' AND '2024-11-28'
AND frto.financial_title_occurrence_type_id = 52
AND frto.created_by = 39
AND fat.title LIKE '%FAT%'
