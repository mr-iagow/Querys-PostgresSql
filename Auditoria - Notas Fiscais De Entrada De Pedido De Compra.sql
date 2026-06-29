SELECT 
inv.document_number AS numero_documento,
inv.entry_date AS data_entrada_nota,
p.name AS fornecedor,
fo.title AS operacao,
fn.title AS natureza_financeira,
cp.description AS empresa_compra_item,
inv.product_acquisition_request_id AS numero_pedido_compra,
invt."description" AS item_nota_compra,
invt.unit_amount AS vlr_unitario,
invt.total_amount AS vlr_total_nota_compra,
invt.units AS quatidade_item_nota,
pat.serial_number AS serial_patrimonio,
pat.tag_number AS numero_patrimonio,
v.name AS usuario_criado_patriomio

FROM invoice_notes AS inv
JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
JOIN companies_places AS cp ON cp.id = inv.company_place_id
JOIN service_products AS sp ON sp.id = invt.service_product_id
JOIN people AS p ON p.id = inv.supplier_id
JOIN financial_operations AS fo ON fo.id = inv.financial_operation_id
LEFT JOIN patrimonies AS pat ON pat.entry_invoice_note_id = inv.id
LEFT JOIN v_users AS v ON v.id = pat.created_by
JOIN financers_natures AS fn ON fn.id = inv.financer_nature_id


WHERE 
DATE (inv.entry_date) BETWEEN '2026-06-20' AND '2026-06-25'
AND inv.product_acquisition_request_id IS NOT NULL 