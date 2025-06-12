SELECT DISTINCT ON (pat.id)
p.name AS responsavel,
pat.title AS tipo,
pat.serial_number AS numero_serial,
pat.tag_number AS numero_patrimonio

FROM patrimonies AS pat
JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_id = pat.id
JOIN patrimony_packing_lists AS ppl ON ppl.id = ppli.patrimony_packing_list_id
JOIN people AS p ON p.id = pat.person_id

WHERE 

ppli.returned = 0
AND pat.service_product_id IS NOT NULL 
and ppli.returned_date IS NULL 
AND p.name ='KELTON CLEMENTE DOS SANTOS'