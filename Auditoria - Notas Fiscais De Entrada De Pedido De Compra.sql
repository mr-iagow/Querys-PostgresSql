SELECT DISTINCT ON (pari.service_product_id,pat.id,par.id)
inv.document_number AS numero_documento,
inv.entry_date AS data_entrada_nota,
p."name" AS fornecedor,
fo.title AS operacao,
cp."description" AS empresa_compra_item,
inv.product_acquisition_request_id AS numero_pedido_compra,
sp.title AS item_nota_compra,
invt.unit_amount  AS vlr_unitario,
invt.gross_amount AS vlr_total_nota_compra,
pari.units AS quatidade_item_nota,
pat.serial_number AS serial_patrimonio,
pat.tag_number AS numero_patrimonio,
v.name AS usuario_criado_patriomio,
invt.unit_amount AS valor_unitario

FROM invoice_notes AS inv
 JOIN product_acquisition_requests AS par ON par.id = inv.product_acquisition_request_id
 JOIN product_acquisition_request_items AS pari ON pari.product_acquisition_request_id = par.id
 JOIN service_products AS sp ON sp.id = pari.service_product_id
 JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
 JOIN companies_places AS cp ON cp.id = inv.company_place_id
LEFT JOIN patrimonies AS pat ON pat.entry_invoice_note_id = inv.id
 JOIN financial_operations AS fo ON fo.id = inv.financial_operation_id
LEFT JOIN v_users AS v ON v.id = pat.created_by
 JOIN people AS p ON p.id = par.supplier_id



WHERE DATE (inv.entry_date) BETWEEN '2026-01-01' AND '2026-06-18'
AND par.deleted = FALSE

--ORDER BY inv.entry_date desc
--AND par.id = 7154
