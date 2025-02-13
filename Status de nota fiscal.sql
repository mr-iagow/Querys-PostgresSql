SELECT DISTINCT ON (inv.id)
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = inv.company_place_id) AS local_nota,
inv.client_name AS nome_cliente,
sp.id AS id_plano,
sp.title AS plano,
inv."status" AS id_status,
CASE 
	WHEN inv."status" = 3 THEN 'Rejeitado'
	when inv."status" = 4 THEN 'Ag Retorno'
END AS status,
inv.cnae,
inv.document_number AS numero_documento,
inv.xml_url AS xml,
inv.print_url AS espelho_nota


FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
JOIN service_products AS sp ON sp.id = invt.service_product_id

WHERE DATE (inv.created) >= '2023-05-01'
AND inv.company_place_id IN (1,9,4)
AND inv.financial_operation_id IN  (1,65)
AND inv."status" IN (3,4,8)

