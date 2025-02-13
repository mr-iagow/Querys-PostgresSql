SELECT DISTINCT ON (frt.id)
pa.city as cidade_client,
pa.neighborhood as bairro,
p.name AS nome_cliente,
frt.title AS titulo,
frt.parcel AS parcela,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = frt.company_place_id) AS empresa,
(SELECT ba.description FROM bank_accounts AS ba WHERE ba.id = frt.bank_account_id) AS banco,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = frt.financer_nature_id) AS natureza,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = frt.financial_collection_type_id) AS tipo_cobranca,
DATE (frt.created) AS data_emissao,
frt.expiration_date AS data_vencimento,
frt.original_expiration_date AS data_vencimento_original,
frt.title_amount AS valor_titulo,
frt.title_amount + frt.fine_amount + frt.interest_amount AS valor_total,
(SELECT cty.title FROM contract_types AS cty WHERE cty.id = ct.contract_type_id) AS tipo_contrato,
ct.v_status AS status_contrato

FROM financial_receivable_titles AS frt
LEFT JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
JOIN people AS p ON p.id = frt.client_id
left join people_addresses as pa on pa.person_id = p.id
LEFT JOIN contracts AS ct ON ct.id = frt.contract_id

WHERE 

ct.v_invoice_type = 'Antecipado'
AND frt.p_is_receivable = TRUE 
AND frtt.receipt_date IS NULL 
AND frt.deleted = false