SELECT DISTINCT ON (asi.protocol)
asi.protocol AS protocolo,
t.title AS equipe,
(SELECT it.title FROM incident_types AS it WHERE asi.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id ) AS responsavel_abertura,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS responsavel_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = asi.incident_status_id) AS status_atual,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
CASE 
WHEN a.conclusion_date < a.final_date THEN 'No Prazo' 
WHEN a.conclusion_date > a.final_date THEN 'Fora do Prazo' 
END AS SLA,
a.description AS descricao_solicitacao,
(SELECT au.title from authentication_sites AS au WHERE au.id = asi.authentication_site_id) AS site,
UPPER (SPLIT_PART(SPLIT_PART(asi.beginning_checklist,'"value":"', 2),'"}}',1)) AS checklist_tecnico


FROM assignment_incidents AS asi
INNER JOIN assignments AS a ON a.id = asi.assignment_id
INNER JOIN teams AS t ON t.id = asi.team_id
INNER JOIN incident_types AS it ON asi.incident_type_id = it.id

WHERE 
asi.team_id IN (4)
-- AND asi.incident_type_id <> 1235
AND a.requestor_id IN (129)
and DATE (a.created) BETWEEN '2022-01-01' AND '2023-03-17'
