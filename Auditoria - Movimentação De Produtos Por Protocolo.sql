SELECT 
ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
inv.document_number AS numero_nf_movimentacao,
inv.company_place_name AS empresa,
sp.title AS produto,
v.units AS quantidade,
vu.name AS usuario_criador_nf,
DATE (v.created) AS data_movimentacao

FROM person_product_movimentations AS v
JOIN service_products AS sp ON sp.id = v.service_product_id
JOIN people AS p ON p.id = v.person_id
join assignments AS a ON a.id = v.assignment_id 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN invoice_notes AS inv ON inv.id = v.invoice_note_id
JOIN v_users AS vu ON vu.id = inv.created_by
JOIN incident_types AS it ON it.id = ai.incident_type_id

WHERE DATE (a.conclusion_date) BETWEEN '2024-12-01' AND '2025-11-30'
AND sp.id IN (321, 332, 326, 5347, 605, 336, 337, 338, 5344, 341, 366, 3242, 8227)