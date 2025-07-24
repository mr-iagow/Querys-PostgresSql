SELECT 

ct.contract_number AS numero_contrato,
p."name" AS prefeitura,
ct."description" AS desc_contrato,
sp.title AS plano,
ct.amount AS valor_contrato,
ct.v_status AS status_contrato,
ac.postal_code AS cep,
ac.neighborhood AS bairro,
ac.street_number AS numero_rua,
ac.street AS rua,
ac.city AS cidade,
ac.user AS pppoe

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id
JOIN authentication_contracts AS ac ON ac.contract_id = ct.id
JOIN service_products AS sp ON sp.id = ac.service_product_id


WHERE 

p."name" LIKE '%PREFEITURA%'
AND ct.v_status != 'Cancelado'