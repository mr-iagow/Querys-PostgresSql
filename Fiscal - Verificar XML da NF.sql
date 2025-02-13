SELECT 

inv.document_number,
inv.client_name,
inv.xml_url,
inv.rps_number,
inv.print_url

FROM invoice_notes AS inv


WHERE inv.document_number = 93683