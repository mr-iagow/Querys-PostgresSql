SELECT 

c.id AS id_contrato,
p.name AS nome_cliente, 
p.tx_id AS cpf_cnpj,
CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' WHEN p.type_tx_id != 1 THEN 'CPF' END AS tipo_cliente,
frt.title AS titulo_fatura,
frt.title_amount AS valor_fatura,
frt.expiration_date AS data_vencimento,
(SELECT nf.title FROM financers_natures AS nf WHERE frt.financer_nature_id = nf.id) AS natureza_financeira,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = frt.financial_collection_type_id) AS tipo_cobranca,
c.v_status AS status_contrato,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato

FROM financial_receivable_titles AS frt 
LEFT JOIN people AS p ON p.id = frt.client_id
LEFT JOIN contracts AS c ON c.id = frt.contract_id

WHERE 

frt.p_is_receivable = TRUE 
---AND frt.origin = 7
AND frt.financial_collection_type_id IN (2,6,8,10,12,14,16,82,78,79,95)