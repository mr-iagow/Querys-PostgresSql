SELECT 
p.name AS nome_cliente,
DATE (fft.created) AS data_criacao,
fft.expiration_date AS data_vencimento,
fft.title_amount AS valor_titulo,
cp.description AS empresa,
fft.title AS fatura,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id =  fft.financer_nature_id) AS natureza_financeira,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca

FROM financial_receivable_titles as fft
left JOIN people AS p ON p.id = fft.client_id
left JOIN companies_places AS cp ON cp.id = fft.company_place_id
left JOIN contracts AS c ON c.id = fft.contract_id
left join financial_collection_types AS fct ON c.financial_collection_type_id = fct.id

WHERE 
DATE (fft.created) BETWEEN '2023-01-01' AND '2023-01-01'
and fft.p_is_receivable = TRUE

