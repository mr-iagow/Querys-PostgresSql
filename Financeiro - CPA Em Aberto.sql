SELECT DISTINCT ON (f.id)
p.name AS fornecedor,
(SELECT tx.name FROM tx_types AS tx WHERE tx.id = p.type_tx_id) AS tipo_fornecedor,
f.created AS data_criacao,
f.entry_date AS data_emissao,
f.expiration_date AS data_vencimento,
f.title_amount AS total,
(SELECT cp.description FROM companies_places  AS cp WHERE cp.id = f.company_place_id) AS empresa,
(SELECT v.name FROM v_users AS v WHERE v.id = f.created_by) AS responsavel,
f.title AS titulo,
(SELECT cci.title FROM financial_cost_centers AS cci WHERE cci.id = cc.financial_cost_center_id) AS centro_custo,
CASE WHEN f.situation = 1 THEN 'em_aprovacao' WHEN f.situation = 2 THEN 'aprovado' END AS status,
(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = f.bank_account_id) AS conta,
(SELECT fn.title FROM financers_natures AS fn WHERE f.financer_nature_id = fn.id) AS natureza_financeira,
(SELECT fo.title FROM financial_operations AS fo WHERE f.financial_operation_id = fo.id) AS operacao_fatura,
CASE 
WHEN f.type = 1 THEN 'Provisorio'
WHEN f.type = 2 THEN 'Definitivo'
END AS tipo,
CASE 
WHEN f.origin = 1 THEN 'Financeiro'
WHEN f.origin = 2 THEN 'Dcto Entrada'
END AS origem,
f.complement AS complemento


FROM financial_payable_titles AS f
INNER JOIN people AS p ON f.supplier_id = p.id
LEFT JOIN financial_divide_cost_center_previsions AS cc ON  f.id = cc.financial_payable_title_id
LEFT JOIN financers_natures AS fn1 on fn1.id = f.financer_nature_id

WHERE  f.financer_nature_id = 231
  AND f.deleted = FALSE
  AND f.expiration_date::date >= DATE '2025-09-01'
  AND f.expiration_date::date <= DATE '2026-12-31'