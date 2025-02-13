SELECT


(SELECT P.name FROM people AS p WHERE p.id = pe.person_id) AS responsavel,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = pe.service_product_id) AS patrimonio,
inv.document_number AS nota,
sp.code AS codigo_produto,
CASE
WHEN pe.signal = 1 THEN 'entrada'
WHEN pe.signal = 2 THEN 'saida'
END AS tipo,
(SELECT um.title FROM units_measures AS um WHERE um.id = pe.first_units_measure_id) AS medida,
pe.units AS unidade,
ai.protocol AS protocolo_saida,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_solicitacao,
ai.incident_type_id ,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = inv.company_place_id) AS empresa,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
DATE (pe.created) AS data_movimentacao,
pe.unit_amount AS valor_unidade,
(SELECT v.name FROM v_users AS v WHERE v.id = inv.created_by) AS movimentador


FROM person_product_movimentations AS pe  

LEFT JOIN
	invoice_notes AS inv ON pe.invoice_note_id = inv.id
INNER JOIN
	people AS p ON p.id = pe.person_id
LEFT JOIN
	v_users AS v ON p.name = v.name

LEFT JOIN
	assignments AS a ON a.id = pe.assignment_id
LEFT JOIN
	assignment_incidents AS ai ON a.id = ai.assignment_id
LEFT JOIN
	service_products AS sp ON  pe.service_product_id = sp.id

	

WHERE 
DATE(pe.created) BETWEEN '2021-01-01' AND curdate()
AND v.team_id IN (1,1003,1011)
AND sp.id = 349