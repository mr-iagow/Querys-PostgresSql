SELECT DISTINCT ON (inv.id)


inv.client_name AS nome_cliente,
(SELECT v.name FROM v_users AS v WHERE v.id = inv.created_by) AS usuário_faturador,
(SELECT sp.title from service_products AS sp WHERE sp.id = ini.service_product_id) AS taxa_ou_plano



FROM invoice_notes AS inv
INNER JOIN invoice_note_items AS ini ON ini.invoice_note_id = inv.id 
LEFT JOIN service_products AS sep ON ini.service_product_id = sep.id

WHERE DATE (inv.created) BETWEEN '2023-05-01' AND '2023-05-31'
AND  inv.created_by = 57

