SELECT --DISTINCT ON (ci.id)
c.id AS cod_contrato,
c.contract_number AS numero_contrato,
p.name AS nome_cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.bill_company_place_id) AS local_contrato,
p.city AS cidade,
p.neighborhood AS bairro,
CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' WHEN p.type_tx_id != 1 THEN 'CPF' END AS tipo,
c.v_status AS status_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) operacao_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = C.contract_type_id) AS tipo_contrato,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ci.service_product_id) AS plano,
c.amount AS valor_contrato,
(SELECT sp.selling_price FROM service_products AS sp WHERE sp.id = ci.service_product_id) AS valor_plano,
c.observation AS observacao_contrato


FROM contracts AS c
inner JOIN people AS p ON p.id = c.client_id
INNER JOIN contract_items AS ci ON ci.contract_id = c.id

WHERE
c.v_status IN ('Normal','Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') 
AND v_stage = 'Aprovado'
AND c.bill_company_place_id = 1
AND ci.deleted = FALSE
--AND c.id IN (3939,46078, 9985, 382) -- 1# Normal, 2# Plano Diferenciado, 3# Dois Serviços, 4# Suspenso,