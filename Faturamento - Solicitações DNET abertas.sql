SELECT DISTINCT ON (ai.protocol)

it.title AS tipo_solicitacao,
ai.protocol AS protocolo,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
a."description" AS texto_abertura,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe,
ai.client_id AS id_client,
(SELECT p.name FROM people AS p WHERE p.id = ai.client_id) AS cliente

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id

WHERE 

DATE (a.created) >= '2024-12-05'
AND it.title LIKE '%DNET%'
AND ai.client_id IS NOT NULL 