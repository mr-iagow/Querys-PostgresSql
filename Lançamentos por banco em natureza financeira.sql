SELECT DISTINCT ON (fp.id)
		(SELECT cp.description FROM companies_places AS cp WHERE cp.id = fp.company_place_id) AS empresa,
		(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = fp.financer_nature_id) AS natureza_financeira,
		(SELECT bk.description FROM bank_accounts AS bk WHERE bk.id = fp.bank_account_id) AS conta_banco,
		fp.created AS data_criacao,
		fp.date AS data_lancamento,
		fp.competence AS competencia,
		CASE 
		WHEN fp."signal" = 1 THEN 'C'
		WHEN fp."signal" = 2 THEN 'D'
		END AS sinal,
		fp.amount AS valor_lancamento,
		CASE 
		WHEN fp.origin = 3 THEN 'CRE'
		WHEN fp.origin = 1 THEN 'LDR'
		END AS origem
FROM financial_postings AS fp
		WHERE fp.financer_nature_id = 51
		AND fp.bank_account_id IN (4,7,198,155,54,55,32,154,33,77,34)
		AND DATE (fp.date) BETWEEN '2023-07-01' AND '2023-07-31'
		AND fp.deleted = FALSE 