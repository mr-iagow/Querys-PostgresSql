SELECT --DISTINCT ON (frt.
p.name AS nome_cliente,
frt.id AS id_fatura,
frt.title AS titulo,
frt.parcel AS parcela,
frt.company_place_id AS id_empresa,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = frt.company_place_id) AS empresa,
(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = frt.bank_account_id) AS banco,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = frt.financer_nature_id) AS natureza,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = frt.financial_collection_type_id) AS tipo_cobranca,
DATE (frt.created) AS data_emissao,
frt.expiration_date AS data_vencimento,
frt.original_expiration_date AS data_vencimento_original,
frt.title_amount AS valor_titulo,
frt.title_amount + frt.fine_amount + frt.interest_amount AS valor_total

FROM financial_receivable_titles AS frt
LEFT JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
JOIN people AS p ON p.id = frt.client_id


WHERE 

DATE (frt.created)  BETWEEN cast(date_trunc('month', current_date-INTERVAL '5 month') as date) AND DATE(curdate())
--DATE (frt.created)  BETWEEN '2024-08-01' AND '2024-09-04'
AND frt.p_is_receivable = TRUE 
AND frtt.receipt_date IS NULL 
--AND p.name = 'ABMAEL NONATO CUNHA'