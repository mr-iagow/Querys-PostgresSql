SELECT 

SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo,
DATE (a.created) AS data_abertura,
TO_CHAR(a.created, 'HH24:MI:SS') AS hora_abertura,
date(a.conclusion_date) AS data_encerramento,
TO_CHAR(a.conclusion_date, 'HH24:MI:SS') AS hora_encerramento,
date(a.final_date) AS data_prazo,
TO_CHAR(a.final_date, 'HH24:MI:SS') AS hora_prazo,
(r.seconds_worked/3600):: INTEGER AS horas_em_atendimento,
(r.seconds_worked % 3600)/60:: INTEGER AS minutos_em_atendimento,
CASE 
WHEN DATE (a.conclusion_date) <= DATE (a.final_date) THEN 'Não' 
WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN 'Sim' 
END AS em_atraso,
CASE 
    WHEN DATE (a.conclusion_date) > DATE (a.final_date) THEN datediff(DATE(a.conclusion_date),DATE(a.final_date)) 
    WHEN DATE (a.conclusion_date) < DATE (a.final_date) THEN NULL 
END AS dias_atraso,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = a.company_place_id) AS empresa,
(SELECT it.title FROM incident_status AS it WHERE it.id = ai.incident_status_id) AS status,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS setor,
(SELECT sa.title FROM sector_areas AS sa WHERE sa.id = ai.sector_area_id) AS setor_origem,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS solicitante,
(SELECT sa.description FROM service_level_agreements AS sa where sa.id = ai.service_level_agreement_id) AS situacao,
(SELECT sat.title FROM service_level_agreement_types AS sat WHERE sat.id =  ai.service_level_agreement_type_id) AS sla

FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
left JOIN people AS p ON p.id = ai.client_id
left JOIN reports AS r ON r.assignment_id = a.id

WHERE 
DATE (a.conclusion_date) BETWEEN '$data_inicial_encerramento' AND '$data_final_encerramento'
and ai.team_id IN (1011)
AND ai.incident_status_id IN (4)