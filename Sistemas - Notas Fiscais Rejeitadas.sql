SELECT DISTINCT ON (inv.id)

inv.document_number AS nota,
inv.company_place_name AS empresa,
inv.client_name AS cliente,
c.contract_number AS contrato,
sp.title AS item_nota,
sp."code",
inv.return_motive,
p.tax_percentage

FROM invoice_notes AS inv
LEFT JOIN contracts AS c ON c.id = inv.contract_id
LEFT JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
LEFT JOIN contract_items AS serv ON ag.id = serv.contract_configuration_billing_id AND serv.deleted = FALSE
LEFT JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
LEFT JOIN service_products AS sp ON sp.id = invt.service_product_id
LEFT JOIN people AS P ON P.id = inv.client_id

WHERE 

inv."status" = 3