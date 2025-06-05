SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
p."name" AS cliente,
p.phone AS telefone,
p.cell_phone_1 AS celular,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
CASE WHEN a.created_by IS NULL THEN 'Sem Atendente' ELSE COALESCE((SELECT v.name FROM v_users AS v WHERE v.id = a.created_by), 'Sem Atendente') END AS aberto_por,
DATE (a.created) AS data_abertura_protocolo,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS cat_1,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_protocolo



FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN people AS p ON p.id = a.requestor_id
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id

WHERE

DATE (a.created) BETWEEN '2025-01-01' AND '2025-05-31'
AND ai.team_id = 1006