SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
p.name as cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = a.company_place_id) AS LOCAL,
(SELECT it.title FROM incident_status AS it WHERE it.id = ai.incident_status_id) AS status,
(SELECT sa.description FROM service_level_agreements AS sa where sa.id = ai.service_level_agreement_id) AS situacao,
(SELECT sat.title FROM service_level_agreement_types AS sat WHERE sat.id =  ai.service_level_agreement_type_id) AS sla,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_Solicitacao,
pa.street_type AS tipo_rua,
pa.street AS rua,
pa.city AS cidade,
pa.neighborhood AS bairro,
pa.number AS numero,
pa.latitude AS latitude,
pa.longitude AS longitude,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS setor,
(SELECT sa.title FROM sector_areas AS sa WHERE sa.id = ai.sector_area_id) AS setor_origem,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS atendente_origem,
DATE (a.created) AS data_abertura,
date(a.final_date) AS data_prazo,
DATE(r.created) AS data_encerramento,
CASE 
WHEN DATE (a.conclusion_date) <= DATE (a.final_date) THEN 'Não' 
WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN 'Sim' 
END AS em_atraso,
CASE 
    WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN datediff(DATE(a.conclusion_date),DATE(a.final_date)) 
    WHEN DATE (a.conclusion_date) < DATE (a.final_date) THEN NULL 
END AS dias_atraso,
DATE (ai.date_to_start) AS data_incio_atendimento,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS solicitante,
(SELECT sc.title from solicitation_classifications AS sc WHERE sc.id = ai.solicitation_classification_id) AS contexto_solicitacao,
(SELECT sp.title FROM solicitation_problems AS sp WHERE sp.id = ai.solicitation_problem_id) AS problema_solicitacao,
a.rework AS retrabalho

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
left JOIN people AS p ON p.id = ai.client_id
JOIN reports AS r ON r.assignment_id = a.id
LEFT JOIN people AS pp ON pp.id = a.responsible_id
left JOIN people_addresses AS pa ON pa.person_id = p.id

WHERE 


DATE (r.created) BETWEEN '2023-11-01' AND '2023-12-05'
AND ai.team_id IN (1003)
AND r.beginning_geoposition_latitude IS NOT NULL
AND r.progress >= 100
AND pp.outsourced = TRUE
AND a.rework = 0
AND ai.solicitation_classification_id = 36
