SELECT DISTINCT ON (ct.id)
p.name AS cliente,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
p.phone AS telefone,
pa.city AS cidade,
pa.street AS rua,
pa.number AS numero_casa,
pa.neighborhood AS bairro,
pa.address_complement AS complemento,
pa.postal_code AS cep,
pa.state AS estado,
pa.latitude,
pa.longitude,
DATE (ct.created) AS data_venda,
ca.activation_date AS data_ativacao,
CASE WHEN ct.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = cpo.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = ct.seller_1_id) END AS vendedor,
(SELECT serv.title FROM service_products AS serv WHERE serv.id = pl.service_product_id) AS plano,
ct.amount AS valor_plano,
CASE WHEN ppg.people_group_id IS NULL THEN 'Sem equipe' 
ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id
LEFT JOIN people_addresses AS pa ON pa.person_id = p.id
LEFT JOIN crm_person_oportunities AS cpo ON cpo.contract_id = ct.id
LEFT JOIN authentication_contracts AS pl ON cpo.contract_id = pl.contract_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = ct.seller_1_id
LEFT JOIN contract_assignment_activations AS ca ON ca.contract_id = ct.id

WHERE 
ct.v_status != 'Cancelado'
AND ct.company_place_id = 10