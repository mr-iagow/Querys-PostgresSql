SELECT DISTINCT ON (ct.id)
p.name AS cliente,
p.city AS cidade,
p.neighborhood AS bairro,
	CASE 
WHEN ct.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = ct.created_by) 
ELSE (SELECT p.name FROM people AS p WHERE p.id = ct.seller_1_id) 
END AS vendedor,
	CASE 
WHEN ppg.people_group_id IS NULL THEN 'Sem Vendedor' 
ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) 
END AS equipe,
CASE 
	WHEN caa.activation_date IS NULL THEN ct.beginning_date
	ELSE caa.activation_date
	END AS data_ativacao,
DATE(ct.cancellation_date) AS data_cancelamento,
ce.description AS motivo_cancelamento,
(SELECT ce.title FROM contract_event_types AS ce WHERE ce.id = cet.id) AS evento_cancelamento



FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = ct.seller_1_id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = ct.id
left JOIN contract_events AS ce ON ct.id = ce.contract_id
JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id


WHERE DATE(ct.cancellation_date) BETWEEN '2024-04-01' AND '2024-06-27'
AND ct.company_place_id != 3
AND cet.id IN (110, 154, 156, 157, 158, 159, 163, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 184, 203, 195, 196, 197, 198, 199, 194, 202, 201, 204, 190, 187, 185, 188, 275, 225, 226, 230, 237, 251, 252, 263, 200, 243, 205, 268, 274, 276, 270, 192, 261, 186, 267, 191, 193, 264, 265, 266, 246, 277, 278, 279, 280, 281, 282, 183, 283, 288, 284, 285, 287, 286, 289, 189, 290)