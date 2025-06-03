SELECT DISTINCT ON (ai.protocol)
  ai.protocol AS protocolo,
  (SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
  ct.v_status AS status_contrato,
  ct.cancellation_date AS data_cancelamento,
  ct.suspension_date AS data_suspensao,
  CASE
    WHEN ct.v_status = 'Bloqueio Financeiro' THEN
      LAST_VALUE( DATE (ce.date)) 
        OVER ( PARTITION BY ct.id  ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) ELSE NULL END AS data_bloqueio_evento,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS responsavel_abertura,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS cat_1,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5,
(SELECT ss.title FROM solicitation_solutions AS ss WHERE ss.id = ai.solicitation_solution_id) AS solucao

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id
JOIN contract_service_tags AS ctag  ON ctag.id = ai.contract_service_tag_id
JOIN contracts AS ct  ON ct.id = ctag.contract_id
LEFT JOIN contract_events AS ce  ON ce.contract_id = ct.id  AND ce.description LIKE '%Contrato bloqueado por %'

WHERE 
  DATE(a.created) BETWEEN '$abertura01' AND '$abertura02'
  AND ai.incident_type_id IN (1280,2173,2220,2221);
