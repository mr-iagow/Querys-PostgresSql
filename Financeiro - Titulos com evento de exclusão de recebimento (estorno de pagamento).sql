SELECT DISTINCT ON (frt.id) 
v.name AS usuario_resposavel,
cp."description" AS empresa,
p."name" AS cliente,
fat.title AS fat,
frt.amount AS valor,
frto."description" AS descricao_exclusao,
frto.created AS data_exclusao

FROM financial_receipt_titles AS frt
JOIN financial_receivable_titles AS fat ON fat.id = frt.financial_receivable_title_id
JOIN financial_receivable_title_occurrences AS frto ON frto.financial_receivable_title_id = fat.id
JOIN v_users AS v ON v.id = frto.created_by
JOIN companies_places AS cp ON cp.id = frt.company_place_id
JOIN people AS p ON p.id = frt.client_id

WHERE 
DATE (frto.date) BETWEEN '2025-10-22' AND '2025-10-22'
AND frto.financial_title_occurrence_type_id = 52
--AND frto.created_by = 39
--AND fat.title LIKE '%FAT%'
