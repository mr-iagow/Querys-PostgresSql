SELECT DISTINCT ON (fft.id)
p.name AS cliente_titulo,
tt.name AS tipo_cliente,
ctt.title AS tipo_contrato,
fft.title AS fatura,
fft.complement AS complemento,
DATE (fft.created) AS data_criacao,
fft.expiration_date AS data_vencimento,
fft.original_expiration_date AS data_original_vencimento,
fft.title_amount AS valor_titulo,
cp.description AS local_fatura,
fn.title AS natureza_financeira_titulo,
fo.title AS operacao_financeira_titulo,
fo2.title AS operacao_financeira_conntrato,
fct.title AS tipo_cobranca_titulo,
CASE WHEN fft.deleted = TRUE THEN 'Sim' ELSE 'Não' END AS titulo_deletado,
CASE WHEN fft.finished = TRUE THEN 'Sim' ELSE 'Não' END AS titulo_baixado,
frt2.receipt_date AS data_recebimento


FROM financial_receivable_titles as fft
LEFT JOIN financial_receipt_titles AS frt2 ON frt2.financial_receivable_title_id = fft.id
JOIN people AS p ON p.id = fft.client_id
JOIN companies_places AS cp ON cp.id = fft.company_place_id
left JOIN contracts AS c ON c.client_id = p.id
JOIN financers_natures AS fn ON fn.id = fft.financer_nature_id
LEFT JOIN financial_operations AS fo ON fo.id = fft.financial_operation_id
LEFT JOIN financial_operations AS fo2 ON fo2.id = c.operation_id
JOIN financial_collection_types AS fct ON fct.id = fft.financial_collection_type_id
LEFT JOIN contract_types AS ctt ON ctt.id = c.contract_type_id
JOIN tx_types AS tt ON tt.id = p.type_tx_id

WHERE 
DATE (fft.expiration_date) BETWEEN '$data01' AND '$data02'
-- and fft.p_is_receivable = TRUE
AND fft.deleted = FALSE 

