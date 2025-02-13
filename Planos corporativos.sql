SELECT DISTINCT ON (inv.id)

inv.client_name AS nome_cliente,
p.tx_id,
sp.id AS id_plano,
sp.title AS plano,
inv."status" AS id_status,
CASE 
	WHEN inv."status" = 3 THEN 'Rejeitado'
	when inv."status" = 4 THEN 'Ag Retorno'
END AS status
-- inv.cnae,
-- inv.document_number AS numero_documento

FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
JOIN service_products AS sp ON sp.id = invt.service_product_id
JOIN people AS p ON p.id = inv.client_id

WHERE DATE (inv.created) >= '2023-05-01'
AND inv.company_place_id IN (1,9,4)
AND inv.financial_operation_id IN  (1,65)
AND inv."status" = 3