SELECT DISTINCT ON (frt.id)
p."name" AS cliente,
ct.contract_number AS numero_contrato,
cp."description" AS empresa,
frt.title AS fatura,
(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = frt.bank_account_id) AS banco,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = frt.financer_nature_id) AS natureza,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = frt.financial_collection_type_id) AS tipo_cobranca,
fo.title AS operacao,
sp.title AS servico_contrato,
DATE (frt.created) AS data_emissao,
frt.expiration_date AS data_vencimento,
frt.original_expiration_date AS data_vencimento_original,
frt.title_amount AS valor_titulo,
frt.title_amount + frt.fine_amount + frt.interest_amount AS valor_total,
(SELECT cty.title FROM contract_types AS cty WHERE cty.id = ct.contract_type_id) AS tipo_contrato,
ct.v_status AS status_contrato

FROM financial_receivable_titles AS frt
JOIN people AS p ON p.id = frt.client_id
LEFT JOIN contracts AS ct ON ct.id = frt.contract_id
LEFT JOIN contract_items AS ci ON ci.contract_id = ct.id AND ci.deleted = FALSE --AND 
LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id --AND sp.huawei_profile_name IS NOT NULL
JOIN financial_operations AS fo ON fo.id = frt.financial_operation_id
JOIN companies_places AS cp ON cp.id = frt.company_place_id

WHERE 

DATE (frt.created)  BETWEEN '2025-10-01' AND '2025-10-20'
--DATE (frt.created)  BETWEEN '2024-11-01' AND '2024-11-30'
AND frt.deleted = FALSE 
AND frt.company_place_id = 3
AND frt.title LIKE '%FAT%'