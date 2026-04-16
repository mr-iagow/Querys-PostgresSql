SELECT DISTINCT ON (ct.id,ppl.id)

ct.contract_number AS numero_contrato,
p."name" AS cliente,
pat.tag_number AS AS patrimonio,
pat.serial_number AS serial_equipamento

FROM contracts AS ct
JOIN contract_service_tags AS ctag ON ctag.contract_id = ct.id AND ctag.deleted = FALSE 
LEFT JOIN patrimony_packing_lists AS ppl ON ppl.contract_service_tag_id = ctag.id 
LEFT JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id AND ppli.returned = 0
LEFT JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
LEFT JOIN people AS p ON p.id = ct.client_id

WHERE 

ct.company_place_id = 10
AND ct.v_status != 'Cancelado'
AND ct.deleted = FALSE
AND ppli.returned = 0