SELECT
it.code AS cod_tipo_solicitacao,
it.title AS tipo_solicitacao,
CASE
	WHEN it.solicitation_type = 1 THEN 'Externa'
	WHEN it.solicitation_type = 2 THEN 'Interna'
	WHEN it.solicitation_type = 3 THEN 'Avulsa'
	WHEN it.solicitation_type = 4 THEN 'Venda'
END AS tipo_solicitacao,
(SELECT t.title FROM teams AS t WHERE t.id = it.team_id) AS equipe_solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = (SELECT t.person_id FROM teams AS t WHERE t.id = it.team_id)) AS gestor_equipe_solicitacao,
(SELECT sa.title FROM sector_areas AS sa WHERE sa.id = it.sector_area_id) AS area_solicitacao,
(SELECT sla.description FROM service_level_agreements AS sla WHERE sla.id = it.service_level_agreement_id) AS situacao,
(SELECT slat.title FROM service_level_agreement_types AS slat WHERE slat.id = it.service_level_agreement_type_id) AS tipo_sla,

(SELECT sla.code FROM service_level_agreements AS sla WHERE sla.id = it.service_level_agreement_id) AS cod_situacao,
(SELECT sla.client_hours FROM service_level_agreements AS sla WHERE sla.id = it.service_level_agreement_id) AS prazo_horas,
(SELECT sla.seconds_to_start FROM service_level_agreements AS sla WHERE sla.id = it.service_level_agreement_id) AS prazo_minutos,
'1.01' AS catalogo,
it.code AS cod_tipo_solicitacao

FROM incident_types AS it

WHERE it.deleted = FALSE
AND it.active = TRUE
AND it.solicitation_type IN (1)
-- AND it.id IN (1010,1034)