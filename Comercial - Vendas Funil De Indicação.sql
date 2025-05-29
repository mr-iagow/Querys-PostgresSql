SELECT DISTINCT ON (cfun.id)
fun.title AS funil,
p.name AS cliente,
 CASE
	WHEN ci.v_status IS NULL THEN 'negociacao_perdida'
	ELSE ci.v_status 
 END AS status_contrato,
 p.phone AS telefone,
 p.cell_phone_1 AS celular1,
 pa.city AS cidade,
 pa.neighborhood AS bairro,
 v."name" AS vendedor,
 ci.id AS id_contrato,
 CASE 
 	WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' 
  	ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) 
  END AS equipe,
 	CASE 
 		WHEN cfun.activation_date IS NULL THEN DATE(a.conclusion_date) 
 		ELSE date(caa.activation_date) 
 		END AS data_ativacao

FROM crm_funnels AS fun
left JOIN crm_consult_selling_steps AS cfun ON cfun.crm_funnel_id = fun.id
JOIN people AS p ON p.id = cfun.person_id
JOIN people_addresses AS pa ON pa.id = cfun.people_address_id
JOIN people AS v ON v.id = cfun.responsible_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = cfun.responsible_id
left JOIN contracts AS ci ON ci.client_id = cfun.person_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = ci.id
LEFT JOIN assignments AS a ON a.requestor_id = p.id 
LEFT JOIN assignment_incidents AS ai ON ai.assignment_id = a.id and ai.incident_type_id IN (1005,1006,1901,1899,1900)	AND DATE(a.conclusion_date) >= DATE(cfun.activation_date) 

WHERE

fun.id = 3
AND cfun.deleted = FALSE 
--AND p."name" = 'FRANCISCO EUSEBIO DE SOUZA'
AND cfun.activation_date IS NOT NULL 
AND ci.id >=99999



