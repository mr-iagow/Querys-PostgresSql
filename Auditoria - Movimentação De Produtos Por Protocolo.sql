SELECT 
ai.protocol AS protocolo,
inv.document_number AS numero_nf_movimentacao,
sp.title AS produto,
v.units AS quantidade,
vu.name AS usuario_criador_nf,
v.created AS data_movimentacao

FROM person_product_movimentations AS v
JOIN service_products AS sp ON sp.id = v.service_product_id
JOIN people AS p ON p.id = v.person_id
join assignments AS a ON a.id = v.assignment_id 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN invoice_notes AS inv ON inv.id = v.invoice_note_id
JOIN v_users AS vu ON vu.id = inv.created_by

WHERE 
ai.protocol = 3093427