SELECT 

ct.title AS tipo_contrato,
CASE WHEN ct."active" = TRUE THEN 'Sim' ELSE 'Não' END AS ativo,
cp."description" AS empresa,
fo.title AS operacao,
fo2.title AS operacao_secundaria,
fct.title AS tipo_cobranca,
fn.title AS natureza,
fn2.title AS natureza_secundaria


FROM contract_types AS ct
LEFT JOIN companies_places AS cp ON cp.id  = ct.company_place_id
LEFT JOIN financial_operations AS fo ON fo.id = ct.financial_operation_id
LEFT JOIN financial_operations AS fo2 ON fo2.id = ct.second_financial_operation_id
LEFT JOIN financial_collection_types AS fct ON fct.id = ct.financial_collection_type_id 
LEFT JOIN financers_natures AS fn ON fn.id = ct.financer_nature_id
LEFT JOIN financers_natures AS fn2 ON fn2.id = ct.second_financer_nature_id


WHERE ct.deleted = FALSE AND ct.id != 15