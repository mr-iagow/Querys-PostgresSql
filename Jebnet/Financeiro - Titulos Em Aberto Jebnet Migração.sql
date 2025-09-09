SELECT 
p."name" AS cliente,
frt.title AS titulo,
cp."description" AS empresa,
frt.contract_id AS id_contrato,
fo.title AS operacao,
fn.title AS natureza

FROM financial_receivable_titles AS frt
JOIN companies_places AS cp ON cp.id = frt.company_place_id
JOIN people AS p ON p.id = frt.client_id
JOIN financial_operations AS fo ON fo.id = frt.financial_operation_id
JOIN financers_natures AS fn ON fn.id = frt.financer_nature_id

WHERE frt.company_place_id = 13
AND frt.title LIKE '%FAT%'
AND frt.deleted = FALSE 
AND frt.finished = FALSE 
and frt.p_is_receivable = TRUE 