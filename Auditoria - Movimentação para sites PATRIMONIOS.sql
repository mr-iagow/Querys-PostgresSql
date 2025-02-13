SELECT --DISTINCT ON (ai.protocol)

(SELECT v.name FROM v_users AS v WHERE v.id = inv.created_by) AS colaborador,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = ini.service_product_id) AS patrimonio,
sp.code AS cod_produto,
pat.serial_number AS numero_serial,
pat.tag_number AS etiqueta,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
ai.protocol AS protocolo,
(SELECT aut.title FROM authentication_sites AS aut WHERE  aut.id = ai.authentication_site_id) AS site,
CASE
WHEN pack.returned = 1 THEN 'Sim'
WHEN pack.returned = 0 THEN 'Nao'
END  AS retorno ,
pack.out_invoice_note_id AS nota,
DATE (inv.created) AS data_emissao_nota,
CASE
WHEN inv.signal = 2 THEN 'saida'
WHEN inv.signal = 1 THEN 'Entrada'
END AS tipo

FROM invoice_notes AS inv
INNER JOIN invoice_note_items as ini ON inv.id = ini.invoice_note_id
INNER JOIN patrimonies AS pat ON pat.id = ini.patrimony_id
INNER JOIN v_users AS vu ON vu.id = inv.created_by
INNER JOIN patrimony_packing_list_items AS pack ON pack.out_invoice_note_id = inv.id
INNER JOIN patrimony_packing_lists AS pp ON pp.id = pack.patrimony_packing_list_id
INNER JOIN assignments AS a ON a.id = pp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
INNER JOIN service_products AS sp ON sp.id = pat.service_product_id

WHERE inv.financial_operation_id = 12
AND date(inv.created) BETWEEN '2024-05-01' AND '2024-05-31'
AND pat.return_pending = FALSE