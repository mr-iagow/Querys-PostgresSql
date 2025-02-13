SELECT DISTINCT ON (ai.protocol)
p.name AS nome_cliente,
ai.protocol,
(SELECT it.title FROM incident_types AS it WHERE ai.incident_type_id = it.id) tipo_solicitacao,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT vu.name FROM v_users AS vu WHERE vu.id = a.created_by) AS responsevel_abertura,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_atual,
p.id AS id_cliente,
c.id AS id_contrato,
(SELECT ce.date FROM contract_events AS ce WHERE ce.contract_id = c.id AND ce.contract_event_type_id = 3 AND ce.date BETWEEN '2020-01-01' AND '2023-01-20') AS data_aprovacao,
caa.activation_date AS data_aprovacao_solicitacao,
CASE 
WHEN aut.user IS NULL THEN acco.user
WHEN aut.user IS NOT NULL THEN aut.user
END AS pppoe

FROM assignments AS a 
left JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
left JOIN contracts AS c ON c.id = cst.contract_id
left JOIN people AS p ON p.id = a.requestor_id
left JOIN authentication_contracts AS aut ON aut.contract_id = c.id
LEFT JOIN authentication_contract_connection_occurrences AS acco ON acco.contract_id = c.id
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id

WHERE 
DATE (a.conclusion_date ) BETWEEN '2022-12-01' AND '2022-12-31'
and ai.incident_type_id IN  (1006,21,1005)
AND ai.incident_status_id IN  (4)

