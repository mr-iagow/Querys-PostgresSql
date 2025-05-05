SELECT 
cp."description" AS empresa,
fct.title AS tipo_cobranca,
fn.title AS natureza,
fo.title AS operacao,
frt.title AS titulo,
frt.document_amount AS valor


FROM financial_receivable_titles AS frt
JOIN financers_natures AS fn ON fn.id = frt.financer_nature_id
JOIN financial_operations AS fo ON fo.id = frt.financial_operation_id
JOIN companies_places AS cp ON cp.id = frt.company_place_id
JOIN financial_collection_types AS fct ON fct.id = frt.financial_collection_type_id


WHERE 

frt.financial_collection_type_id IN  (2,6,8,10,12,14,16,78,79,82,95)
and frt.p_is_receivable = TRUE 
and frt.deleted = FALSE 
--AND cp.id = 9
--AND frt.id in (2,6,8,10,12,14,16,78,79,82,95)

ORDER BY cp.id 
