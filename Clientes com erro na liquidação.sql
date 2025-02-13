SELECT 
		frr.client_id AS id_cliente,
		c.id AS id_contrato,
		(SELECT p.name FROM people AS p WHERE p.id = frr.client_id) AS cliente,
		(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = frt.bank_account_id) AS conta_bancaria,
		(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
		(SELECT fn.file_name FROM financial_remittance_returns AS fn WHERE fn.id = frr.financial_remittance_return_id) AS arquivo,
		(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = frt.financial_collection_type_id) AS tipo_cobranca,
		frr.receipt_date AS data_recebimento,
		frr.financial_receivable_title_id AS id_titulo,
		frt.title AS titulo,
		frr.title_amount AS valor_titulo,
		frr.receipt_amount AS valor_recebido,
		frr.tariff_amount AS valor_tarifa,
		frr.increase_amount AS valor_incrementado,
		frr.fine_amount AS valor_multa,
		frr.abatement_amount AS valor_abatimento,
		frr.discount_amount AS valor_desconto,
		frr.balance AS balanco,
		frr.credited_amount AS valor_creditrado,
		frr.other_credit_amount AS outro_valor_de_credito,
		frr.other_debit_amount AS outro_valor_debito

FROM financial_remittance_return_registers AS frr
JOIN financial_receivable_titles AS frt ON frt.id = frr.financial_receivable_title_id
LEFT JOIN contracts AS c ON c.client_id = frr.client_id

WHERE  
		frr.other_debit_amount != 0
		AND DATE (frr.receipt_date) >= '2024-01-01'
