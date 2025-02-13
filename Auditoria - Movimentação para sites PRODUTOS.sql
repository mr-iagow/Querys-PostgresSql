SELECT DISTINCT ON (pe.id)
(SELECT v.name FROM v_users AS v WHERE v.id = pe.created_by) AS colaborador,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = pe.service_product_id) AS produto,
(SELECT sp.code FROM service_products AS sp WHERE sp.id = pe.service_product_id) AS cod_produto,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
ai.protocol AS protocolo,
(SELECT aut.title FROM authentication_sites AS aut WHERE  aut.id = ai.authentication_site_id) AS site,
inv.document_number AS nota,
DATE (inv.created) AS data_emissao_nota,
pe.units AS qtd_movimentada

FROM invoice_notes AS inv
LEFT  JOIN invoice_note_items as ini ON inv.id = ini.invoice_note_id
LEFT JOIN person_product_movimentations AS pe ON pe.invoice_note_id = inv.id
LEFT JOIN assignments AS a ON a.id = pe.assignment_id 
LEFT JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN patrimony_packing_list_items AS pack ON pack.out_invoice_note_id = inv.id
LEFT JOIN patrimony_packing_lists AS pp ON pp.id = pack.patrimony_packing_list_id
LEFT JOIN incident_types AS iti ON iti.id = ai.incident_type_id

WHERE 

date(pe.created) BETWEEN '2024-05-01' AND '2024-05-31'
AND iti.solicitation_type = 2
