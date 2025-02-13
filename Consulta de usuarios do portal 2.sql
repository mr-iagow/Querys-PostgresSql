SELECT 

p.id AS id_cliente,
p.name AS cliente,
CASE 
	WHEN pu.active = 'true' THEN 'ativo'
	WHEN pu.active =  'false' THEN 'inativo'
END AS status_usuario,
DATE (pu.created) AS data_criacao_usuaruio,
DATE (c.created) AS data_criacao_contrato,
DATE (pu.last_portal_login) AS data_ultimo_login_portal,
DATE (pu.last_app_login) AS data_ultimo_login_app,
CASE WHEN ppg.people_group_id IS NULL THEN 'Sem equipe' 
ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe,
(SELECT vu.name FROM v_users AS vu WHERE vu.id =  c.created_by) AS vendedor

FROM contracts AS c
left JOIN people AS p ON p.id = c.client_id
left join person_users AS pu ON pu.person_id = p.id
left JOIN v_users AS v ON v.id = pu.created_by
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id

WHERE c.v_status IN ('Normal','Demonstração', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo') 
AND v_stage = 'Aprovado'
AND c.company_place_id != 3
AND ppg.people_group_id IN (11,14,16,12,13,15,19)
AND DATE (c.created) BETWEEN '2023-08-01' AND '2023-09-20'
