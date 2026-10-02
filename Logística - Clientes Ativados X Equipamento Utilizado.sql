SELECT --DISTINCT ON (cc.contract_number)

ai.protocol AS protocolo,
it.title AS tipo_solicitacao,
p2."name" AS responsavel_solicitacao,
cc.contract_number AS numero_contrato,
caa.activation_date AS data_ativacao,
pa.city AS cidade,
pa.neighborhood AS bairro,
pat.serial_number AS serial_equipamento_vinculado_contrato,
pat.tag_number as patrimonio_equipamento_vinculado_contrato,
pat.title AS tipo_equipamento_vinculado_contrato,
CASE WHEN ppli.returned = 1 THEN 'Sim' ELSE 'Nao' END AS equipamento_retornado,
inv.document_number AS nota_remessa_comodato

FROM contract_assignment_activations AS caa
JOIN assignments AS a ON a.id = caa.assignment_id
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id
JOIN contracts AS cc ON cc.id = caa.contract_id
LEFT JOIN people_addresses AS pa ON pa.id = cc.people_address_id
JOIN people AS p2 ON p2.id = a.responsible_id
LEFT JOIN patrimony_packing_lists AS ppl ON ppl.assignment_id = caa.assignment_id
LEFT JOIN patrimony_packing_list_items AS ppli ON ppli.patrimony_packing_list_id = ppl.id
LEFT JOIN patrimonies AS pat ON pat.id = ppli.patrimony_id
LEFT JOIN invoice_notes AS inv ON inv.id = ppli.out_invoice_note_id


WHERE 

caa.activation_date >= '2026-08-01'::date 
AND caa.activation_date < '2026-08-31'::date + INTERVAL '1 day'
AND cc.deleted = FALSE 

--AND ppli.returned = 0
--AND ai.protocol = 3803493

--ORDER BY caa.activation_date asc