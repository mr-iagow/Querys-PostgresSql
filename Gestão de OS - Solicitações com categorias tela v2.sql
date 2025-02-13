SELECT
 
ai.protocol AS protocolo, 
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS cat_1,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5,
DATE (a.conclusion_date) AS data_encerramento


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
left join solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id

WHERE 
--ai.protocol = 2361553
DATE (a.conclusion_date) BETWEEN '2024-05-14' AND '2024-05-15'
AND ai.team_id = 1003