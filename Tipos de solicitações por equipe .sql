SELECT

(SELECT t.title FROM teams AS t WHERE t.id = it.team_id) AS equipe,
(SELECT sa.title FROM sector_areas AS sa WHERE sa.id = it.sector_area_id) AS area_do_setor,
it.code AS numero_fila,
it.title AS tipo_solicitacao,
it.default_text AS descricao,
slat.title AS tipo_sla,
sla.description AS sla_atendimento

FROM incident_types AS it 
LEFT JOIN service_level_agreements AS sla ON it.service_level_agreement_id = sla.id
left JOIN service_level_agreement_types AS slat ON slat.id = sla.service_level_agreement_type_id

WHERE it.team_id = 1080
AND it.active = true