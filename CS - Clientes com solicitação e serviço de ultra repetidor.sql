SELECT DISTINCT ON (ai.protocol)
c.id AS cod_contrato,
p.name AS cliente,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
p.phone AS telefone,
--pl.title AS servico_vinculado,
c.v_status AS situacao,
ai.protocol AS protocolo,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao


FROM contracts AS c
JOIN people AS p ON p.id = c.client_id
JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
JOIN contract_items AS serv ON ag.id = serv.contract_configuration_billing_id AND serv.deleted = FALSE
LEFT JOIN service_products AS pl ON pl.id = serv.service_product_id
LEFT JOIN assignments AS a ON a.requestor_id = c.client_id
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id

WHERE c.v_status IN ('Normal','Demonstra╬ô├╢┬úΓö¼Γòæ╬ô├╢┬úΓö£Γòæo', 'Cortesia', 'Suspenso', 'Bloqueio Financeiro', 'Bloqueio Administrativo')
AND v_stage = 'Aprovado'
AND pl.id IN (3591, 3801, 3592, 6199, 5525, 5526, 6200, 3802, 5527, 5528, 2761, 6169, 6170, 2762, 6366, 6367)
--AND c.id = 549
--AND c.id = 49509
AND ai.incident_type_id IN (1318, 1317, 1362)
AND ai.incident_status_id !=8