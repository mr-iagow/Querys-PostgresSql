SELECT 

inv.document_number,
cp."description",
invt.description,
invt.units,
pat.serial_number,
pat.tag_number

FROM invoice_notes AS inv
JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
LEFT JOIN patrimonies AS pat ON pat.id = invt.patrimony_id
JOIN companies_places AS cp ON cp.id = inv.company_place_id

WHERE inv.document_number = 362921