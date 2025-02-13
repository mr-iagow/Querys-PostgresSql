SELECT DISTINCT ON (ct.id)

ct.id AS flow_var_contrato,
p.name AS nome,
p.cell_phone_1 AS celular_1,
p.phone AS celular_2,
p.email,
p.tx_id AS cpf_cnpj

FROM contracts AS ct
JOIN contract_events AS ce ON ce.contract_id = ct.id 
JOIN people AS p ON p.id = ct.client_id

WHERE 

ct.v_status != 'Cancelado'
AND ct.contract_type_id IN  (1,2,4,10,11,12)
AND ct.company_place_id NOT IN (12,11,3)
AND ct.stage IN (1,4)
AND ct.client_acceptance = 3
and ct.id not in (64097,54623,54561,54532)
