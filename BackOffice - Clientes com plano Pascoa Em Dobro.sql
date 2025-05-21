SELECT DISTINCT ON (ai.protocol)
ai.protocol AS protocolo,
cp.description AS empresa,
pa.city AS cidade,
(SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) AS responsavel_abertura,
pg.title AS equipe,
c.id AS cod_contrato,
ctag.service_tag AS etiqueta,
sp.title AS plano,
DATE (ci.created) AS data_vinculo_plano,
CASE 
    WHEN sp.selling_price = 0.0 OR sp.selling_price = 0.01 THEN c.amount
    ELSE sp.selling_price
END AS valor,
(SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
(SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS atendente,
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
LEFT JOIN person_people_groups AS ppg ON (SELECT v.name FROM v_users AS v WHERE v.id = a.created_by) = (SELECT p.name FROM people AS p WHERE p.id = ppg.person_id)
LEFT JOIN people_groups AS pg ON pg.id = ppg.people_group_id
JOIN contract_items AS ci ON ci.contract_id = c.id AND ci.deleted = FALSE 
JOIN service_products AS sp ON sp.id = ci.service_product_id AND sp.huawei_profile_name IS NOT NULL 
JOIN companies_places AS cp ON cp.id = c.company_place_id
JOIN people_addresses AS pa ON pa.person_id = a.requestor_id

WHERE 
DATE (ci.created) BETWEEN '2025-05-01' AND '2025-05-21' -- Data de vinculo do plano
and ai.incident_type_id IN ( 2273, 2275, 2274 )
AND sp.id IN (7981, 7936, 7896, 7909, 7911, 7897, 7899, 7898, 7901, 7912, 7914, 7913, 7900, 7915, 7937, 7954, 7955, 7982)