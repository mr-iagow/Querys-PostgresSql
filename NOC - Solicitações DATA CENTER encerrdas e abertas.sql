SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
(select ast.title FROM authentication_sites AS ast WHERE ast.id = ai.authentication_site_id) AS site_abertura,
(SELECT p.name FROM v_users AS p WHERE p.id = a.created_by) AS aberto_por,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
a.description AS texto_abertura,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS responsval,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
LAST_VALUE(r.description) OVER (PARTITION BY a.id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS relato_encerramento


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN reports AS r ON r.assignment_id = a.id

WHERE 
ai.incident_type_id IN (1667,1668,1669)
AND a.created >= '2024-01-02'
