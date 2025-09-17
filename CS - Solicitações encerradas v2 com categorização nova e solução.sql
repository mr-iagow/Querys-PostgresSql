SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
p.name as cliente,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS atendente_origem,
DATE (a.created) AS data_abertura,
date(a.final_date) AS data_prazo,
date(a.conclusion_date) AS data_encerramento,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS cat_1,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5,
(SELECT ss.title FROM solicitation_solutions AS ss WHERE ss.id = ai.solicitation_solution_id) AS solucao


FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
left JOIN people AS p ON p.id = ai.client_id
JOIN people_addresses AS pa ON pa.person_id = p.id
LEFT join solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id

WHERE 
DATE (a.conclusion_date) BETWEEN '2025-09-01' AND '2025-09-15'
AND ai.team_id = 1003
AND ai.incident_status_id = 4

--ai.protocol = 3171356 