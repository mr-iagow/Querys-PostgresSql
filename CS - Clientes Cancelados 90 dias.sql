SELECT DISTINCT ON (ai.protocol)


p.name AS cliente,
ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_1) AS cat_1,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_2) AS cat_2,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4,
(SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5,
sp.title AS plano,
c.amount AS valor_mensalidade,
DATE (c.cancellation_date) AS data_cancelamento,
CASE 
	WHEN caa.activation_date IS NULL THEN DATE(c.created) 
	ELSE date(caa.activation_date) 
END AS data_ativacao,
    DATEDIFF(DATE(c.cancellation_date), 
             CASE 
                 WHEN caa.activation_date IS NULL THEN DATE(c.created) 
                 ELSE DATE(caa.activation_date) 
             END) AS dias_entre_instalacao_e_cancelamento

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN people AS p ON p.id = a.requestor_id 
JOIN contract_service_tags AS ctag ON ctag.id = ai.contract_service_tag_id
LEFT JOIN contracts AS c ON c.id = ctag.contract_id
JOIN incident_types AS it ON it.id = ai.incident_type_id
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
JOIN contract_items AS ci ON ci.contract_id = c.id AND ci.deleted = FALSE 
JOIN service_products AS sp ON sp.id = ci.service_product_id AND sp.huawei_profile_name IS NOT NULL 

WHERE 

ai.incident_type_id IN (1059, 1274, 1442)
AND  datediff
			(DATE(c.cancellation_date), 
             CASE 
                 WHEN caa.activation_date IS NULL THEN DATE(c.created) 
                 ELSE DATE(caa.activation_date) 
             END) <= 90
             