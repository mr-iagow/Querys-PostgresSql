SELECT 
scm."code" cod_erp,
(SELECT it.title FROM incident_types AS it WHERE it.id = scmi.incident_type_id) AS tipo_solicitacao,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_1) AS cat_1,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_2) AS cat_2,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_3) AS cat_3,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_4) AS cat_4,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = scm.service_category_id_5) AS cat_5,
(SELECT ss.title FROM solicitation_solutions AS ss WHERE ss.id = sm.solicitation_solution_id) AS solucoes_vinculadas


FROM solicitation_category_matrices AS scm
left JOIN solicitation_category_matrix_solutions AS sm ON sm.solicitation_category_matrix_id = scm.id
LEFT JOIN solicitation_category_matrix_incident_types AS scmi ON scmi.solicitation_category_matrix_id = scm.id

WHERE 

scm.active = TRUE
AND scm.deleted = FALSE 


and scm.service_category_id_1 IN (461,228,884,1243,1123,1337)

ORDER BY scm.service_category_id_1 ASc