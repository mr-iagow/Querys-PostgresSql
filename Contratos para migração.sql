SELECT 

c.id AS id_contrato,
p.name AS nome_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' WHEN p.type_tx_id != 1 THEN 'CPF' END AS tipo,
c.amount AS valor_contrato,
c.v_status AS status_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) operacao_contrato,
(SELECT ct.title FROM contract_types AS ct WHERE ct.id = C.contract_type_id) AS tipo_contrato

FROM contracts AS C
JOIN people AS p ON p.id = c.client_id


WHERE 


c.v_status IN ('Normal','Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') AND v_stage = 'Aprovado'
AND c.company_place_id = 8