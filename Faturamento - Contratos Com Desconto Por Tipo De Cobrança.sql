SELECT 

c.contract_number AS numero_contrato,
c.id AS id_contrato,
ctt.title AS tipo_contrato,
c.v_status AS status_contrato,
CASE 
  WHEN c.discount_use_contract = 1 THEN 'Conforme Contrato'
  WHEN c.discount_use_contract = 0 THEN 'Conforme Tipo De Cobrança'
  WHEN c.discount_use_contract = 2 THEN 'Não Aplica Desconto'
END AS possui_desconto_no_contrato,
c.discount_value AS valor_desconto,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.second_financial_operation_id) AS operacao_secundaria_contrato,
p."name" AS cliente

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
JOIN contract_types AS ctt ON ctt.id = c.contract_type_id

WHERE c.discount_use_contract = 0
AND c.company_place_id = 12
AND c.v_status != 'Cancelado'