SELECT
    c.id AS cod_contrato,
    p.name AS cliente,
    CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' ELSE 'CPF' END AS tipo_cliente,
    pa.city AS cidade,
    pa.neighborhood AS bairro,
    c.amount AS valor_contrato,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.bill_company_place_id) AS local_fatura,
    c.v_status AS status_contrato,
    (SELECT ct.title FROM contract_types AS ct WHERE ct.id = c.contract_type_id) AS tipo_contrato,
    (SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
    (SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
    (SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca,
    (SELECT fo.title FROM financial_operations AS fo WHERE fo.id = ag.financial_operation_id) AS operacao_agrupador,
    (SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS natureza_agrupador,
    (SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = ag.financial_collection_type_id) AS tipo_cobranca_agrupador,
    (SELECT sp.title FROM service_products AS sp WHERE sp.id = aut.service_product_id) AS plano_conexao,
    it.description AS descricao_item
FROM contracts AS c
INNER JOIN people AS p ON p.id = c.client_id
INNER JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id AND ag.deleted = FALSE
INNER JOIN contract_items AS it ON it.contract_configuration_billing_id = ag.id AND it.deleted = FALSE
-- uma autenticação por contrato (a ativa mais recente): não multiplica as linhas
LEFT JOIN LATERAL (
    SELECT ac.service_product_id
    FROM authentication_contracts AS ac
    WHERE ac.contract_id = c.id AND ac.active
    ORDER BY ac.id DESC
    LIMIT 1
) AS aut ON TRUE
LEFT JOIN people_addresses AS pa ON pa.id = c.people_address_id
WHERE c.v_status IN ('Normal', 'Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo')
  AND c.v_stage = 'Aprovado'
  AND c.deleted = FALSE
  AND c.company_place_id = 9