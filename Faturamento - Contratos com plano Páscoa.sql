SELECT DISTINCT ON (ci.contract_id,p.id)

c.id AS id_contrato,
p."name" AS cliente,
cp."description" AS empresa,
sp.title AS plano,
c.amount AS valor_contrato,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS natureza_agrupador,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = ag.financial_collection_type_id) AS tipo_cobranca_agrupador

FROM contracts AS c
JOIN contract_items AS ci ON ci.contract_id = c.id AND ci.deleted = FALSE 
JOIN service_products AS sp ON sp.id = ci.service_product_id AND sp.huawei_profile_name IS NOT NULL 
left JOIN people AS p ON p.id = c.client_id
left JOIN companies_places AS cp ON cp.id = c.company_place_id
left JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id AND ag.financial_collection_type_id IS NOT NULL AND ag.financer_nature_id IS NOT NULL AND ag.deleted = false 

WHERE

sp.id IN (7981, 7936, 7896, 7909, 7911, 7897, 7899, 7898, 7901, 7912, 7914, 7913, 7900, 7915, 7937, 7954, 7955, 7982)
--sp.id = 7899