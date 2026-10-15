SELECT DISTINCT ON (frt.id)
    p.name                AS cliente,
    p.id                  AS cliente_id,
    COALESCE(NULLIF(TRIM(pa.city), ''),         NULLIF(TRIM(p.city), ''))         AS cidade,
    COALESCE(NULLIF(TRIM(pa.neighborhood), ''), NULLIF(TRIM(p.neighborhood), '')),
    tt.name					  AS tipo_cliente,
    ct.title              AS tipo_contrato,
    c.amount              AS valor_contrato,
    frt.title             AS titulo,
    frt.id                AS titulo_id,
    comp_fat.description  AS local_fatura,
	 comp_rec.description  AS local_recebimento,
	 bacc.description      AS conta_liquidacao,
    CASE WHEN frt.deleted  = TRUE THEN 'sim' ELSE 'nao' END AS titulo_deletado,
    CASE WHEN frt.finished = TRUE THEN 'sim' ELSE 'nao' END AS titulo_baixado,
    CASE WHEN frt.renegotiated  = TRUE THEN 'sim' ELSE 'nao' END AS titulo_renegociado,
    TO_CHAR(frt.competence, 'MM-YYYY') AS competencia,
    frt.expiration_date   AS vencimento,
    frt.original_expiration_date AS data_vencimento_original,
    frt2.receipt_date     AS data_recebimento,
    frt.title_amount      AS valor_titulo,
    frt2.amount 			  AS valor_original,
	 frt2.fine_amount      AS multa,
	 frt2.increase_amount  AS juros,
	 frt2.discount_value   AS desconto,
	 ((frt2.amount + frt2.fine_amount + frt2.increase_amount) - frt2.discount_value) AS total_recebido,
	 frt2.bank_tax_amount  AS tarifa_bancaria,
    frt.document_amount   AS valor_documento,
    fin.amount AS tarifa_bancaria_finee,
	 frt2.credit_card_tax  AS taxa_cartao,
	 pf.title  				  AS forma_pagamento,
    fn.title              AS natureza_financeira_titulo,
    fo.title              AS operacao_financeira_titulo,
    frt2.complement       AS complemento_titulo_recebido
    
FROM financial_receivable_titles AS frt
JOIN people AS p ON p.id = frt.client_id
JOIN financers_natures AS fn ON fn.id = frt.financer_nature_id
JOIN financial_operations AS fo ON fo.id = frt.financial_operation_id
JOIN tx_types AS tt ON tt.id = p.type_tx_id
LEFT JOIN financial_receipt_titles AS frt2 ON frt2.financial_receivable_title_id = frt.id
LEFT JOIN financial_integrations_fees AS fin ON fin.financial_receivable_title_id = frt.id
LEFT JOIN contracts AS c ON c.client_id = p.id
LEFT JOIN people_addresses AS pa ON pa.id = c.people_address_id
LEFT JOIN contract_types AS ct ON ct.id = c.contract_type_id
LEFT JOIN companies_places AS comp_fat ON frt.company_place_id = comp_fat.id
LEFT JOIN companies_places AS comp_rec ON frt2.company_place_id = comp_rec.id
LEFT JOIN payment_forms AS pf ON pf.id = frt2.payment_form_id
LEFT JOIN bank_accounts AS bacc ON frt2.bank_account_id = bacc.id

WHERE 
frt.title LIKE 'FAT%'
AND frt.renegotiated = TRUE
AND frt.expiration_date >= '2026-01-01'
AND frt.expiration_date <=  '2026-10-01'
