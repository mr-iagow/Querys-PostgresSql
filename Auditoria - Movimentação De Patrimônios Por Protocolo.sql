SELECT 
ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
inv.document_number AS numero_nf_movimentacao,
inv.company_place_name AS empresa,
pat.title AS equipamento,
pat.serial_number AS serial_equipamento,
pat.tag_number AS patrimonio_equipamento,
v."name" AS usuario_criador_nf,
DATE (ppl.created) AS data_movimentacao

FROM patrimony_packing_lists AS ppl
JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
JOIN v_users AS v ON v.id = ppl.created_by
join assignments AS a ON a.id = ppl.assignment_id 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
left JOIN service_products AS sp ON sp.id = pat.service_product_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN invoice_notes AS inv ON inv.id = ppli.out_invoice_note_id

WHERE DATE (a.conclusion_date) BETWEEN '2024-12-01' AND '2025-11-30'
AND sp.id = 8227