SELECT DISTINCT ON (notas.id)
date(notas.issue_date) AS emissao,
p.id AS cod_pessoa,
notas.client_name AS cliente,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
fat.expiration_date AS vencimento,
notas.sale_request_id AS pedido_venda,
date(srp.expiration) AS venc_pedido,
notas.billing_competence AS competencia,
notas.document_number AS nota_fiscal,
notas.rps_number AS numero_rps,
CASE WHEN notas.status IN (3,9,10) THEN 'Sim' ELSE 'Nao' END AS nota_cancelada,
DATE (notas.cancellation_date) AS data_cancelamento_nota,
notas.cancellation_motive AS motivo_cancelamento,
notas.total_amount_gross AS valor_bruto,
notas.total_amount_liquid AS valor_liquido,
notas.discounts AS descontos,
notas.additions AS acrescimos,
notas.issqn_amount AS issqn,
notas.pis_amount as pis,
notas.cofins_amount AS cofins,
notas.csll_amount AS csll,
notas.irrf_amount AS irrf,
notas.inss_amount AS inss,
notas.icms_amount AS icms,
notas.base_icms_amount AS bc_icms,
cp.description AS local_nota,
ct.title AS tipo_contrato,
fccc.title AS tipo_cobranca_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = notas.financial_operation_id) AS operacao,
(SELECT nf.title FROM financers_natures AS nf WHERE notas.financer_nature_id = nf.id) AS natureza_financeira,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = notas.invoice_serie_id) AS serie,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = notas.financial_collection_type_id) AS tipo_cobranca_nota,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = fat.financial_collection_type_id) AS tipo_cobranca_titulo,
c.amount AS valor_contrato,
c.v_status AS status_contrato,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = notas.created_by) AS usuario_criador_nota,
CASE WHEN notas.issqn_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS issqn_retido,
case when p.csll_deducted = 0 THEN 'Não' WHEN p.csll_deducted = 2 then 'Sim' else 'Normal' end AS pis_retido,
case when p.csll_deducted = 0 THEN 'Não' WHEN p.csll_deducted = 2 then 'Sim' else 'Normal' end AS cofins_retido, 
CASE WHEN notas.csll_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS csll_retido,
CASE WHEN notas.irrf_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS irrf_retido,
CASE WHEN notas.inss_deducted = TRUE THEN 'Sim' ELSE 'Não' END AS inss_retido

FROM invoice_notes AS notas
INNER JOIN people AS p ON p.id = notas.client_id
LEFT JOIN contracts AS c ON c.id = notas.contract_id
LEFT JOIN contract_types AS ct ON ct.id = c.contract_type_id
LEFT JOIN financial_collection_types AS fccc ON fccc.id = c.financial_collection_type_id 
LEFT JOIN financial_receivable_titles AS fat ON fat.invoice_note_id = notas.id
LEFT JOIN sale_request_parcels AS srp ON srp.sale_request_id = notas.sale_request_id
LEFT JOIN companies_places AS cp ON cp.id = notas.company_place_id

WHERE date(notas.issue_date) BETWEEN '2025-10-01' AND '2025-10-31' -- Alterado de out_date para issue_date por conta do faturamento antecipado da LB Jebnet
AND notas.financial_operation_id IN (1,15,25,26,34,46,63,65,104)
AND notas.status NOT IN (4,5)
AND notas.id NOT IN (975130 /*, 967966*/)
AND notas.document_number IS NOT NULL 
--AND notas.document_number = 7367
GROUP BY notas.id, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39
