SELECT
DATE(notas.created) AS data_alocacao,
notas.document_number AS nota_fiscal,
vp.responsible_name AS responsavel,
(SELECT p.name FROM people AS p WHERE p.id = ai.client_id) AS cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_cliente,
notas.company_place_name AS empresa,
(SELECT invs.title FROM invoice_series AS invs WHERE invs.id = notas.invoice_serie_id) AS serie,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = notas.financial_operation_id) AS operacao,
vp.service_product_title AS produto,
vp.allocated_amount AS quantidade,
vp.first_unit_measure_title AS unidade,
ai.protocol AS protocolo,
(SELECT inct.title FROM incident_types AS inct WHERE ai.incident_type_id = inct.id) AS tipo_os

FROM v_allocated_products AS vp
INNER JOIN invoice_notes AS notas ON notas.id = vp.invoice_note_id
INNER JOIN assignments AS a ON a.id = vp.assignment_id
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts AS c ON c.id = ctag.contract_id


WHERE DATE(notas.created) BETWEEN '2023-02-02' AND '2023-02-02'
and vp.allocated_amount > 0