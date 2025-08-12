SELECT 

ba."description" AS banco,
fpt.complement AS complemento,
fpt.expiration_date AS vencimento,
cpa.payment_date AS data_pagamento,
cpa.discount_value AS descontos,
p."name" AS fornecedor,
cp."description" AS LOCAL,
fo_titulo.title AS operacao_financeira,
fn.title AS natureza_financeira,
fpt.title_amount AS valor_titulo

FROM financial_payable_titles AS fpt
JOIN bank_accounts AS ba ON ba.id = fpt.bank_account_id
LEFT JOIN financial_paid_titles AS cpa ON cpa.financial_payable_title_id = fpt.id
JOIN people AS p ON p.id = fpt.supplier_id
JOIN companies_places AS cp ON cp.id = fpt.company_place_id
JOIN financial_operations AS fo_titulo ON fo_titulo.id = fpt.financial_operation_id
JOIN financers_natures AS fn ON fpt.financer_nature_id = fn.id

WHERE 

fpt.title = '164961'