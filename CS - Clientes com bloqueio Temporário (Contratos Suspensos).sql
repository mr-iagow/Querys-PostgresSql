SELECT DISTINCT ON (ct.id)

ct.id AS id_contrato,
p."name" AS cliente,
p.cell_phone_1 AS celular_1,
p.phone AS telefone,
ctag.service_tag AS etiqueta,
ce."description" AS descricao,
cet.title AS evento,
 DATE (ce.created) AS data_evento

FROM contracts AS ct
JOIN people AS p ON p.id = ct.client_id 
LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = ct.id
LEFT JOIN contract_events AS ce ON ce.contract_id = ct.id
LEFT JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id

WHERE 

DATE (ce.created) BETWEEN '2024-09-01' AND '2024-09-30'
and ct.company_place_id NOT IN (3,11,12)
AND ct.v_status = 'Suspenso'
AND cet.id IN (207, 209, 210, 211, 212, 215, 216, 217, 219, 220, 221, 222, 223, 224, 231, 254, 255, 256, 257, 258, 259, 206, 208, 218, 253)
