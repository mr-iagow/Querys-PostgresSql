SELECT DISTINCT ON (asi.protocol)
asi.protocol AS protocolo,
t.title AS setor,
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
a.description AS descricao_solicitacao


FROM assignment_incidents AS asi
INNER JOIN assignments AS a ON a.id = asi.assignment_id
INNER JOIN teams AS t ON t.id = asi.team_id
INNER JOIN incident_types AS it ON asi.incident_type_id = it.id

WHERE 
asi.team_id = 5
and DATE(a.conclusion_date) BETWEEN '2022-11-01' AND '2022-12-10'
