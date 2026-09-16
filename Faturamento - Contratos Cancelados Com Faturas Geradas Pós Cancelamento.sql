WITH eventos_cancelamento AS (
    SELECT 
        ce.id AS event_id,
        ce.contract_id,
        ce.created AS data_evento,
        cet.title AS evento_cancelamento
    FROM contract_events ce
    JOIN contract_event_types cet 
        ON cet.id = ce.contract_event_type_id
        AND to_tsvector('portuguese', cet.title) @@ to_tsquery('portuguese', 'Cancelamento')
    WHERE ce.created >= '2026-08-01' AND ce.created < '2026-08-08'
    AND cet.id <> 229
)
SELECT
ec.evento_cancelamento,
DATE(ec.data_evento) AS data_evento_cancelamento,
ctt.title AS tipo_contrato,
cp.description AS empresa,
ct.v_status AS status_contrato,
p.name AS cliente,
frt.title AS titulo_gerado_pos_data_cancelamento,
CASE WHEN frt.finished = TRUE THEN 'SIM' ELSE 'NAO' END AS baixado,
CASE WHEN frt.deleted = TRUE THEN 'SIM' ELSE 'NAO' END AS deletado,
frt.document_amount,
sp.title AS item,
fo.title AS operacao_fatura,
fct.title AS tipo_cobranca_fatura,
fo2.title AS operacao_contrato
   
FROM eventos_cancelamento AS ec
JOIN contracts AS ct ON ct.id = ec.contract_id
JOIN contract_types AS ctt ON ctt.id = ct.contract_type_id
JOIN companies_places AS cp ON cp.id = ct.company_place_id
JOIN people AS p ON p.id = ct.client_id
LEFT JOIN financial_receivable_titles AS frt 
    													ON frt.client_id = ct.client_id
    													AND frt.contract_id = ct.id
    													AND frt.created >= date_trunc('day', ec.data_evento)
    													AND frt.title LIKE '%FAT%'
LEFT JOIN financial_operations AS fo ON fo.id = frt.financial_operation_id
LEFT JOIN financial_collection_types AS fct ON fct.id = frt.financial_collection_type_id
LEFT JOIN financial_operations AS fo2 ON fo2.id = ct.operation_id
LEFT JOIN sale_requests AS sr ON sr.id = frt.sale_request_id
LEFT JOIN invoice_notes AS inv_direto ON inv_direto.id = frt.invoice_note_id
LEFT JOIN invoice_notes AS inv_via_sr ON inv_via_sr.sale_request_id = sr.id
LEFT JOIN invoice_note_items AS invt ON invt.invoice_note_id = COALESCE(inv_direto.id, inv_via_sr.id)
LEFT JOIN service_products AS sp ON sp.id = invt.service_product_id


ORDER BY p.name desc
