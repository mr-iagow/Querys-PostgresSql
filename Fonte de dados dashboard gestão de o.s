SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_solicitacao,
(SELECT ins.title FROM incident_status AS ins WHERE ai.incident_status_id = ins.id) AS status_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.final_date) AS data_prazo,
DATE (a.conclusion_date) AS data_encerramento,
CASE WHEN curdate() > a.final_date THEN 'Sim' ELSE 'Nao' END AS em_atraso,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsavel

FROM assignments AS a 
INNER JOIN assignment_incidents AS ai ON ai.assignment_id = a.id


WHERE 

DATE (a.conclusion_date) BETWEEN '2023-03-01' AND curdate ()
AND ai.team_id = 1003
AND ai.incident_status_id = 4