SELECT 

ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe_abertura,
(SELECT t.title FROM teams AS t WHERE t.id = ai.team_id) AS equipe_responsavel,
(a.conclusion_date - a.created) AS tempo


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN v_users AS v ON v.id = a.created_by

WHERE 

DATE (a.created) BETWEEN '2024-01-01' AND '2025-01-13'
and ai.team_id = 1003
AND ai.incident_type_id IN (1927,1907,1563,1905,1205,1722,1906,1708,1817,1828,1820, 1204, 1014,1562,1724,1723)
