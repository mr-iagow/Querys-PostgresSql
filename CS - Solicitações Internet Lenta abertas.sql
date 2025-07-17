SELECT 
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
ai.protocol AS protocolo,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS usuario_abertura,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
a.created AS data_hora_abertura,
a.conclusion_date AS data_hora_encerramento,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ss.title FROM solicitation_solutions AS ss WHERE ss.id = ai.solicitation_solution_id) AS solucao

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id


WHERE 

DATE (a.created) BETWEEN '2025-01-01' AND '2025-07-15'
AND ai.incident_type_id = 1073