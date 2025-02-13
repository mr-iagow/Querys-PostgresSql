SELECT --DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
c.id AS cod_contrato,
ctag.service_tag AS etiqueta,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id
left JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts AS c ON c.id = ctag.contract_id

WHERE 
-- DATE (a.conclusion_date) BETWEEN '2023-10-01' AND '2024-01-26'
-- AND 
ai.incident_type_id = 2174
--AND ai.protocol = 2766417
--AND ai.incident_status_id = 4