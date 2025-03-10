SELECT

ai.protocol,
DATE (sr.created) AS data_criacao_pedido,
sr.id AS id_pedido,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
it.title AS tipo_solicitacao,
ins.title AS status_solicitacao,
sr.total_amount AS valor_pedido,
sr.contract_id AS id_contrato,
sr.company_place_id AS id_empresa,
CASE 
	WHEN sr.situation = 3 THEN 'pedido_faturado' ELSE 'pedido_em_aberto' END AS situacao,
(SELECT v.name FROM v_users AS v WHERE v.id = sr.modified_by) AS faturado_por


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN sale_requests AS sr ON sr.id = ai.sale_request_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id

WHERE
DATE (sr.beginning_date) BETWEEN '01-03-2025' AND '10-03-2025'
AND sr.situation = 3
