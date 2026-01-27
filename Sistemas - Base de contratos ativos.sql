SELECT DISTINCT ON (ct.id)
ctt.title AS tipo_contrato,
ct.id  AS id_contrato,
p.id AS id_cliente,
ct.v_status AS status_contrato,
p."name" AS nome_cliente,
p.city AS cidade,
p.neighborhood AS bairro,
p.street AS rua,
p."number" AS numero_casa,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
p.phone AS telefone,
p.email,
ct.collection_day AS dia_vencimento


FROM contracts AS ct
LEFT JOIN people AS p ON p.id = ct.client_id
JOIN contract_types AS ctt ON ctt.id = ct.contract_type_id

WHERE 

ct.v_status != 'Cancelado'
AND ct.v_status != 'Encerrado'
--AND ct.contract_type_id IN (35,36,37,38,39,45)
--AND ct.id != '154474'