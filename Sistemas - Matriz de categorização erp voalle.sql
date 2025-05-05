SELECT DISTINCT ON (ssc.id)
ssc.code AS codigo,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS categoria_1,
ssc.service_category_id_1,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS categoria_2,
ssc.service_category_id_2
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS categoria_3,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS categoria_4,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS categoria_5,
(SELECT it.title FROM incident_types AS it WHERE it.id = scmi.incident_type_id) AS tipo_solicitacao,
(SELECT sla.description FROM service_level_agreements AS sla WHERE sla.id = ssc.service_level_agreement_id) AS sla,
ssc.client_hours AS prazo_horas,
ssc.client_minutes AS prazo_minutos

FROM solicitation_category_matrices AS ssc
LEFT JOIN solicitation_category_matrix_incident_types AS scmi ON scmi.solicitation_category_matrix_id = ssc.id


WHERE 
ssc.active = TRUE
AND ssc.deleted = FALSE
AND ssc.service_category_id_1 = 228

