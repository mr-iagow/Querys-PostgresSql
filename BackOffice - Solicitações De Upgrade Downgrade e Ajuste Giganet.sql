SELECT

ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
vv.name AS aberto_por,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS cat_2,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5,
(SELECT ss.title FROM solicitation_solutions AS ss WHERE ss.id = scms.solicitation_solution_id) AS solucao,
cy.title AS tipo_contrato,
cp.description AS empresa,
p."name" AS cliente,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
cst.service_tag AS etiqueta,
cc.contract_number AS numero_contrato,
a.description AS texto_solicitacao


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN people AS p ON p.id = ai.client_id
LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
LEFT JOIN contracts AS cc ON cc.id = cst.contract_id
JOIN contract_types AS cy ON cy.id = cc.contract_type_id
JOIN companies_places AS cp ON cp.id = cc.company_place_id
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id
JOIN v_users AS vv ON vv.id = a.created_by

WHERE 

it.id IN (2091, 2124, 1991, 1992, 1398, 52, 1606, 1822, 2125, 2504, 1397, 2436, 2156, 2155, 2154, 2437, 2438, 2439, 2174, 2222, 2157, 2153, 1327, 2016, 2018, 2024, 2014, 1776, 1896, 1308, 51, 1328, 1017, 1821, 1330, 2275, 2099, 2101, 2100, 2274, 1974, 1604, 1605, 1823, 2273)
AND DATE (a.created) BETWEEN '28-12-2025' AND '20-01-2026'
AND cc.contract_type_id IN (35,36,37,38,39,45)