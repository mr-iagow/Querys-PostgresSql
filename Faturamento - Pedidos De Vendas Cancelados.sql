SELECT DISTINCT ON (ai.assignment_id)

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
	WHEN sr.situation = 9 THEN 'pedido_cancelado' ELSE 'pedido_em_aberto' END AS situacao,
CASE 
   WHEN sr.cancellation_responsible_id IS NOT NULL 
      THEN (SELECT v.name FROM people AS v WHERE v.id = sr.cancellation_responsible_id)
   ELSE 
      (SELECT v.name FROM v_users AS v WHERE v.id = (SELECT MAX(r.created_by) FROM reports AS r WHERE r.assignment_id = a.id)) END AS responsavel_cancelamento_pedido


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN sale_requests AS sr ON sr.id = ai.sale_request_id
 JOIN incident_types AS it ON it.id = ai.incident_type_id
 JOIN incident_status AS ins ON ins.id = ai.incident_status_id
 JOIN reports AS r ON r.assignment_id = a.id

WHERE
sr.situation = 9
AND DATE (sr.created) BETWEEN '01-03-2025' AND '10-03-2025'
