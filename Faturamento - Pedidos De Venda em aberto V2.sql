SELECT 

ai.protocol,
DATE (a.final_date) AS data_encerramento,
sr.id AS id_pedido,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
it.title AS tipo_solicitacao,
ins.title AS status_solicitacao,
sr.total_amount AS valor_pedido,
sr.contract_id AS id_contrato,
sr.company_place_id AS id_empresa


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN sale_requests AS sr ON sr.id = ai.sale_request_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id


WHERE 
ai.sale_request_id IS NOT NULL 
AND sr.situation = 1
AND DATE (a.final_date) BETWEEN cast(date_trunc('month', current_date-INTERVAL '3 month') as date) AND DATE(CURRENT_DATE)


AND sr.deleted = FALSE 




