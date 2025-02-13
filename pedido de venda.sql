SELECT 
ai.protocol AS protocolo,
(SELECT p.name FROM people AS p WHERE p.id = ai.client_id) AS cliente,
DATE (sr.created) AS data_emissao,
sr.situation AS situcao,
(SELECT v.name FROM v_users AS v WHERE v.id = sr.modified_by) AS usuario_faturamento,
(SELECT v.name FROM v_users AS v WHERE v.id = sr.created_by) AS usuario_abertura
FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
JOIN sale_requests AS sr ON sr.id = ai.sale_request_id


AND 
sr.situation = 3 --todos os pedido que foram faturados ficam com o status igual a 3
AND sr.created BETWEEN '01-12-2023' AND '31-12-2023'
