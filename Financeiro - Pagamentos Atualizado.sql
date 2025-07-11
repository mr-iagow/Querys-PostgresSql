SELECT DISTINCT ON (cpa.id)
cpa.id AS cod_cpa,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = cpa.company_place_id) AS empresa,
(SELECT p.name FROM people AS p WHERE p.id = cpa.supplier_id) AS fornecedor,
CASE WHEN fpt.origin = 2 THEN 'Documento de Entrada' WHEN fpt.origin != 2 THEN 'Financeiro' END AS origem,
CASE WHEN fpt.type = 2 THEN 'Definitivo' WHEN fpt.type != 2 THEN 'Outro' END AS tipo,
fpt.title AS numero_titulo,
fpt.parcel AS parcela,
cpa.increase_amount AS acrescimos,
cpa.discount_value AS desconto,
cpa.fine_amount AS mutla,
cpa.amount AS valor,
cpa.total_amount AS valor_pago,
fpt.issue_date AS data_emissao,
cpa.payment_date AS data_pagamento,
fpt.expiration_date AS vencimento,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = cpa.financer_nature_id) AS natureza_financeira,
(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = cpa.bank_account_id) AS conta,
cpa.complement AS complemento,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = cpa.financial_operation_id) AS operacao,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = cpa.modified_by) AS responsavel,
cc.cost_center_title AS centro_de_custo

FROM financial_paid_titles AS cpa
INNER JOIN financial_payable_titles AS fpt ON fpt.id = cpa.financial_payable_title_id
left JOIN financial_cost_center_performed_view AS cc ON cc.payable_title_id = fpt.id

WHERE cpa.payment_date BETWEEN '2024-06-01' AND '2024-06-30'