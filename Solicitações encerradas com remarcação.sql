SELECT 
a.id,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id ) AS cliente,
asi.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE asi.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS responsavel_encerramento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = rp.created_by)responsavel_remarcacao,
rp.description ,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = asi.incident_status_id) AS status_atual,
DATE (a.created) AS data_abertura,
DATE (rp.modified) AS data_remarcacao


FROM reports AS rp
INNER JOIN assignment_incidents AS asi ON asi.assignment_id = rp.assignment_id
INNER JOIN assignments AS a ON a.id = asi.assignment_id
INNER JOIN teams AS t ON t.id = a.team_id
LEFT JOIN assignment_person_routings AS apr ON apr.id = asi.assignment_id

WHERE 
asi.incident_status_id = 4
AND rp.type = 2
AND rp.progress < 100
AND DATE (a.conclusion_date) BETWEEN '2022-12-01' AND '2022-12-30'
