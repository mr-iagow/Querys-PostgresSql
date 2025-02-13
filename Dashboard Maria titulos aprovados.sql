SELECT DISTINCT ON (fpt.id)
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fpt.company_place_id) AS empresa,
(SELECT p.name FROM people AS p WHERE p.id = fpt.supplier_id) AS fornecedor,
CASE WHEN fpt.type = 2 THEN 'Definitivo' WHEN fpt.type != 2 THEN 'Outro' END AS tipo,
fpt.title AS numero_titulo,
fpt.parcel AS parcela,
fpt.title_amount AS valor_titulo,
fpt.balance AS saldo,
cpa.total_amount AS valor_pago,
fpt.issue_date AS data_emissao,
fpt.entry_date AS data_entrada,
CASE WHEN cpa.payment_date IS NULL THEN 'Em Aberto' ELSE 'Pago' END AS status_pagamento,
fpt.expiration_date AS vencimento,
cpa.payment_date AS data_pagamento,
	CASE 
	WHEN cpa.payment_date IS NOT NULL AND DATE(cpa.payment_date) <= (fpt.expiration_date) THEN 'Não'
	WHEN cpa.payment_date IS NOT NULL AND DATE(cpa.payment_date) > (fpt.expiration_date) THEN 'Sim'
	WHEN cpa.payment_date IS NULL AND  DATE (current_date) <= DATE (fpt.expiration_date) THEN 'Não' 
	WHEN cpa.payment_date IS NULL and DATE (current_date) > DATE (fpt.expiration_date) THEN 'Sim' 
	END AS em_atraso,

	CASE 
	WHEN cpa.payment_date IS NOT NULL AND DATE(cpa.payment_date) <= (fpt.expiration_date) THEN NULL
	WHEN cpa.payment_date IS NOT NULL AND DATE(cpa.payment_date) > (fpt.expiration_date) THEN datediff(DATE(cpa.payment_date),DATE(fpt.expiration_date))
	WHEN cpa.payment_date IS NULL AND  DATE (current_date) <= DATE (fpt.expiration_date) THEN NULL
	WHEN cpa.payment_date IS NULL AND DATE (current_date) > DATE (fpt.expiration_date) THEN datediff(DATE(current_date),DATE(fpt.expiration_date))
	END AS dias_em_atraso,
	
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = fpt.financer_nature_id) AS natureza_financeira,
(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = fpt.bank_account_id) AS conta,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = fpt.created_by) AS usuario_criador,
CASE WHEN fpt.deleted = TRUE THEN 'Sim' ELSE 'Não' END AS excluido,
(SELECT v.name FROM people AS v WHERE v.id = fpt.approver_id) AS aprovador,
fpt.approving_date AS data_aprovacao

FROM financial_payable_titles AS fpt
LEFT JOIN financial_paid_titles AS cpa ON fpt.id = cpa.financial_payable_title_id

WHERE DATE(fpt.issue_date) BETWEEN cast(date_trunc('month', current_date-INTERVAL '3 month') as date) AND DATE(CURRENT_DATE)
AND fpt.deleted = FALSE
and fpt.type = 2