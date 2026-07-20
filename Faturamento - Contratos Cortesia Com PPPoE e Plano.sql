SELECT 

ct.contract_number AS numero_contrato,
p.name AS cliente,
cp.title AS tipo_contrato,
ct.v_status AS status,
ct.v_stage AS estagio,
co.description AS empresa,
COALESCE(ac.user, 'NAO POSSUI PPPOE NO CONTRATO') AS pppoe,
sp.title AS plano


FROM contracts AS ct
JOIN contract_types AS cp ON cp.id = ct.contract_type_id
JOIN companies_places AS co ON co.id = ct.company_place_id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = ct.id
JOIN people AS p ON p.id = ct.client_id
LEFT JOIN service_products AS sp ON sp.id = ac.service_product_id

WHERE ct.contract_type_id IN (4,14,29,31,19,21,43,44,35,39,50,51,24,32) -- Contratos Tipo Cortesia
AND ct.v_status != 'Cancelado'
AND ct.deleted = false
