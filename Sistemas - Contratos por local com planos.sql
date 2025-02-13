SELECT DISTINCT ON (ct.id)

ct.id AS id_contrato,
p."name" AS cliente,
p.phone AS telefone,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
pa.city AS cidade,
pa.street AS rua,
pa."number" AS numero_casa,
pa.address_complement AS complemento,
pa.code_city_id AS cep,
pa.state AS uf,
pa.country AS país,
pa.latitude,
pa.longitude,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS empresa,
caa.activation_date AS data_ativacao,
ct.amount AS valor_contrato,
(SELECT sp.title FROM service_products AS sp where sp.id = ac.service_product_id) AS plano

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id 
LEFT JOIN people_addresses AS pa ON pa.person_id = ct.client_id
left JOIN authentication_contracts AS ac ON ac.contract_id = ct.id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = ct.id

WHERE 

ct.company_place_id IN (10)
AND ct.v_status != 'Cancelado'
AND ct.v_status != 'Encerrado'
AND ac.service_product_id IS NOT null