SELECT DISTINCT ON (ai.protocol)

ai.protocol AS protocolo,
p."name" AS cliente,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS usuario_abertura,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
c.amount AS valor_contrato_atual


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN contracts AS c ON c.client_id = ai.client_id
JOIN people AS p on p.id = a.requestor_id 
LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = c.id


WHERE 
DATE (a.conclusion_date) BETWEEN '2024-07-01' AND '2024-07-31'
and ai.incident_type_id IN (1327,1328,1308,1605,1823,51,1017,1821,1330,52,1606,1822,1604,1605,1823)
AND ai.incident_status_id = 4
--AND ai.incident_type_id = 51
AND c.company_place_id NOT IN (11,12,3)