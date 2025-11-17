SELECT DISTINCT ON (ct.id)

ct.id AS id_contrato,
ct.v_status AS status_contrato,
ac.user AS pppoe,
p."name" AS cliente,
p.phone AS telefone,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
pa.city AS cidade_contrato,
pa.neighborhood AS bairro_contrato,
pa.street AS rua_contrato,
pa."number" AS numero_casa_contrato,
pa.address_complement AS complemento_endereco_contrato,
pa.code_city_id AS cep_contrato,
pa.state AS uf_contrato,
pa.country AS país_contrato,
pa.latitude AS latitude_contrato,
pa.longitude AS longitude_contrato,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS empresa,
ct.amount AS valor_contrato

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id 
LEFT JOIN people_addresses AS pa ON pa.id = ct.people_address_id
left JOIN authentication_contracts AS ac ON ac.contract_id = ct.id
LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = ct.id

WHERE 

ct.company_place_id IN (12)
AND ct.v_status != 'Cancelado'
AND ct.v_status != 'Encerrado'
--AND ac.service_product_id IS NOT null