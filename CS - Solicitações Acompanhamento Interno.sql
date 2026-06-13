SELECT DISTINCT ON (ai.protocol) 
ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
p.name AS cliente,
c.v_status AS status_contrato,
c.contract_number AS numero_contrato,
pa.city AS cidade,
pa.neighborhood AS bairro,
ct.title AS tipo_contrato,
cp.description AS empresa,
ins.title AS status_protocolo,
cat1.title  AS cat_1,
cat2.title  AS cat_2,
cat3.title  AS cat_3,
cat4.title  AS cat_4,
cat5.title  AS cat_5,
sol.title   AS solucao

FROM assignments AS a
 JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
 JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
 JOIN contracts AS c ON c.id  = cst.contract_id
 JOIN people AS p ON p.id = c.client_id
 JOIN people_addresses AS pa ON pa.id = c.people_address_id
 JOIN contract_types AS ct ON ct.id = c.contract_type_id
 JOIN companies_places AS cp ON cp.id = c.company_place_id
 JOIN incident_status AS ins ON ins.id = ai.incident_status_id
 JOIN incident_types AS it ON it.id = ai.incident_type_id
 LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
 LEFT JOIN solicitation_service_categories AS cat1 ON cat1.id = ssc.service_category_id_1
 LEFT JOIN solicitation_service_categories AS cat2 ON cat2.id = ssc.service_category_id_2
 LEFT JOIN solicitation_service_categories AS cat3 ON cat3.id = ssc.service_category_id_3
 LEFT JOIN solicitation_service_categories AS cat4 ON cat4.id = ssc.service_category_id_4
 LEFT JOIN solicitation_service_categories AS cat5 ON cat5.id = ssc.service_category_id_5
 LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id
 LEFT JOIN solicitation_solutions AS sol ON sol.id = scms.solicitation_solution_id

WHERE 

ai.incident_type_id IN (1889,2666,1192) -- DESCONHECIMENTO DE CONTRATO/SSI / AUDITORIA CUSTOMER SUCCESS | C.S / RECLAMAÇÃO/OUVIDORIA SAC
AND DATE (a.created) BETWEEN '2026-06-01' AND '2026-06-10'