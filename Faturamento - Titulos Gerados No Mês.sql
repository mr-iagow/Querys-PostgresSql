SELECT 
c.contract_number AS numero_contrato,
p.name AS cliente,
ct.title AS tipo_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca_contrato,
cp.description AS local_empresa,
DATE (fft.created) AS data_emissao_boleto,
fft.expiration_date AS data_vencimento,
fft.title_amount AS valor_titulo,
fft.title AS titulo_fatura,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id =  fft.financer_nature_id) AS natureza_financeira_titulo,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = fft.financial_operation_id) AS operacao_titulo


FROM financial_receivable_titles as fft
left JOIN people AS p ON p.id = fft.client_id
left JOIN companies_places AS cp ON cp.id = fft.company_place_id
left JOIN contracts AS c ON c.id = fft.contract_id
left join financial_collection_types AS fct ON c.financial_collection_type_id = fct.id
LEFT JOIN contract_types AS ct ON ct.id = c.contract_type_id

WHERE 
DATE (fft.created) BETWEEN '2026-03-01' AND '2026-03-11'
AND fft.deleted = FALSE 
AND fft.title LIKE '%FAT%'