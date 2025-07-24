SELECT 

ct.contract_number AS numero_contrato,
p."name" AS prefeitura,
ct."description" AS desc_contrato,
sp.title AS plano,
ci.unit_amount AS valor,
ct.v_status AS status_contrato


FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id
JOIN contract_items AS ci ON ci.contract_id = ct.id AND ci.deleted = FALSE 
JOIN service_products AS sp ON sp.id = ci.service_product_id


WHERE 

p."name" LIKE '%PREFEITURA%'
AND ct.v_status != 'Cancelado'