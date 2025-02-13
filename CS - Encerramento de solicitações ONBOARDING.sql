SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
p.name as cliente,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) AS tipo_Solicitacao,
(SELECT v.name FROM people AS v WHERE v.id = a.responsible_id) AS atendente,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS atendente_origem,
DATE (a.created) AS data_abertura,
date(a.final_date) AS data_prazo,
date(a.conclusion_date) AS data_encerramento,
a."description" AS descricao_solicita

FROM assignments AS a 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
left JOIN people AS p ON p.id = ai.client_id
JOIN people_addresses AS pa ON pa.person_id = p.id
LEFT join solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id

WHERE 
DATE (a.conclusion_date) BETWEEN '2024-05-01' AND '2024-05-31'
AND ai.incident_type_id IN (1879,1354,1355,9.19,1357)