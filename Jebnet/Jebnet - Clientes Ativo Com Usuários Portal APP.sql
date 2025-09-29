SELECT 

ct.contract_number AS numero_contrato,
cp."description" AS empresa,
ct.v_status AS status_contrato,
ctt.title AS tipo_contrato,
p."name" AS cliente,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
p.phone AS telefone,
p.email,
CASE 
	WHEN pu.active = 'true' THEN 'ativo'
	WHEN pu.active =  'false' THEN 'inativo'
END AS possui_acesso_app_portal,
DATE (pu.created) AS data_criacao_usuaruio

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id
left join person_users AS pu ON pu.person_id = p.id
JOIN companies_places AS cp ON cp.id = ct.company_place_id
JOIN contract_types AS ctt ON ctt.id = ct.contract_type_id

WHERE 

ct.contract_type_id IN (24,25,26)
AND ct.deleted = FALSE 
AND ct.v_status != 'Cancelado'
AND ct.contract_number != '123576'