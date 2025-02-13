SELECT 

inv.document_number,
invt.description,
pat.serial_number,
pat.tag_number

FROM invoice_notes AS inv
JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
JOIN patrimonies AS pat ON pat.id = invt.patrimony_id

WHERE inv.document_number = 566
AND inv.client_name = 'EMX Telecomunicações Ltda.'