SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
ins.title AS status_solicitacao,
v.name AS aberto_por,
p.name AS cliente,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
a.description AS descricao_abertura,
pp.name AS responsavel,
LAST_VALUE(r.description) OVER (PARTITION BY a.id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS relato_encerramento

FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
LEFT JOIN people AS p ON p.id = ai.client_id
JOIN teams AS t ON t.id = ai.origin_team_id
JOIN v_users AS v ON v.id = a.created_by
JOIN reports AS r ON r.assignment_id = a.id
JOIN people AS pp ON pp.id = a.responsible_id


WHERE 

DATE (a.created) BETWEEN '$data01' AND '$data02' -- data abertura
AND ai.origin_team_id = 1037 -- Suporte Avançado
AND ai.team_id = 1003 -- Gestão de O.S