SELECT 
ai.protocol AS protocolo,
pat.title AS equipamento,
pat.serial_number AS serial_equipamento,
pat.tag_number AS patrimonio_equipamento,
v."name" AS usuario_criador_nf,
ppl.created AS data_movimentacao

FROM patrimony_packing_lists AS ppl
JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
JOIN v_users AS v ON v.id = ppl.created_by
join assignments AS a ON a.id = ppl.assignment_id 
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE 

ai.protocol = 3093427