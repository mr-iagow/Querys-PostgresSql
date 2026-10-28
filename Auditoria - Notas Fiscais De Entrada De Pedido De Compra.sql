SELECT 
inv.document_number AS numero_documento,
inv.entry_date AS data_entrada_nota,
p.name AS fornecedor,
fo.title AS operacao,
fn.title AS natureza_financeira,
cp.description AS empresa_compra_item,
inv.product_acquisition_request_id AS numero_pedido_compra,
invt.description AS item_nota_compra,
invt.unit_amount AS vlr_unitario,
CASE WHEN COUNT(*) OVER (PARTITION BY inv.id) = tn.qtd_itens
	AND ROW_NUMBER() OVER (PARTITION BY inv.id ORDER BY invt.id DESC, pat.id DESC) = 1
	THEN ROUND(invt.total_amount::numeric / NULLIF(invt.units, 0) * inv.total_amount_gross::numeric / NULLIF(tn.total_itens, 0), 6)
		+ inv.total_amount_gross::numeric
		- SUM(ROUND(invt.total_amount::numeric / NULLIF(invt.units, 0) * inv.total_amount_gross::numeric / NULLIF(tn.total_itens, 0), 6)) OVER (PARTITION BY inv.id)
	ELSE ROUND(invt.total_amount::numeric / NULLIF(invt.units, 0) * inv.total_amount_gross::numeric / NULLIF(tn.total_itens, 0), 6)
END AS vlr_unitario_total,
CASE WHEN ROW_NUMBER() OVER (PARTITION BY invt.id ORDER BY pat.id) = 1 THEN invt.total_amount END AS vlr_total_nota_compra,
CASE WHEN ROW_NUMBER() OVER (PARTITION BY invt.id ORDER BY pat.id) = 1 THEN invt.units END AS quatidade_item_nota,
CASE WHEN ROW_NUMBER() OVER (PARTITION BY inv.id ORDER BY invt.id, pat.id) = 1 THEN inv.total_amount_gross END AS vlr_total_nota_com_impostos,
pat.serial_number AS serial_patrimonio,
pat.tag_number AS numero_patrimonio,
v.name AS usuario_criado_patriomio

FROM invoice_notes AS inv
JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
JOIN LATERAL (
	SELECT SUM(i2.units)::numeric AS qtd_itens, SUM(i2.total_amount)::numeric AS total_itens
	FROM invoice_note_items AS i2
	WHERE i2.invoice_note_id = inv.id
) AS tn ON true
JOIN companies_places AS cp ON cp.id = inv.company_place_id
JOIN service_products AS sp ON sp.id = invt.service_product_id
JOIN people AS p ON p.id = inv.supplier_id
JOIN financial_operations AS fo ON fo.id = inv.financial_operation_id
LEFT JOIN patrimonies AS pat ON pat.entry_invoice_note_id = inv.id
	AND pat.service_product_id = invt.service_product_id
LEFT JOIN v_users AS v ON v.id = pat.created_by
JOIN financers_natures AS fn ON fn.id = inv.financer_nature_id

WHERE 
DATE (inv.entry_date)  BETWEEN '2026-10-01' AND '2026-10-20'
AND inv.product_acquisition_request_id IS NOT NULL
ORDER BY inv.document_number, invt.id, pat.id