SELECT DISTINCT ON (frt.id)
frt.client_id,
(SELECT p.name FROM people AS p WHERE p.id = frt.client_id) AS cliente,
frt.title AS fatura,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = frt.company_place_id) AS LOCAL,
frto.description AS erro

FROM financial_receivable_titles AS frt 
JOIN financial_receivable_title_occurrences AS frto ON frto.financial_receivable_title_id = frt.id


WHERE 
frto.description LIKE '%na plataforma FineePix%'
AND DATE(frt.created) >= '2024-04-09'
AND frto.financial_title_occurrence_type_id = 88