SELECT DISTINCT ON (ai.protocol, pat.serial_number, cev.id)
p.name AS cliente,
c.contract_number AS numero_contrato,
ai.protocol AS protocolo,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
pp.name AS responsavel_encerramento,
it.title AS tipo_solicitacao,
cttt.title AS tipo_contrato,
CASE 
  WHEN c.discount_use_contract = 1 THEN 'Conforme Contrato'
  WHEN c.discount_use_contract = 0 THEN 'Conforme Tipo De Cobrança'
  WHEN c.discount_use_contract = 2 THEN 'Não Aplica Desconto'
END AS possui_desconto_no_contrato,
c.discount_value AS valor_desconto,
c.v_invoice_type AS tipo_faturamento,
CASE 
	WHEN cev.type = '1' THEN 'Acréscimo'
 	WHEN cev.type = 2 THEN 'Desconto' 
	ELSE 'Sem Eventual Gerado'
 END AS tipo_eventual,
cev.total_amount AS valor_eventual_gerado,
CASE WHEN retirada.protocolo_retirada IS NOT NULL THEN 'Sim' ELSE 'Não' END AS possui_retirada_em_aberto,
retirada.protocolo_retirada,
retirada.tipo_retirada,
reativacao.protocolo_reativacao,
reativacao.relato_abertura_reativacao,
reativacao.data_abertura_reativacao,
reativacao.tipo_reativacao,
reativacao.cat_4,
reativacao.cat_5,
pat.serial_number AS patrimonio,
ppli_pat.out_date AS data_saida_patrimonio,
ppli_pat.returned_date AS data_retorno_patrimonio

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id
LEFT JOIN contract_service_tags cst ON cst.id = ai.contract_service_tag_id
JOIN contracts c ON c.id = cst.contract_id
LEFT JOIN people AS p ON p.id = a.requestor_id
LEFT JOIN people AS pp ON pp.id = a.responsible_id
LEFT JOIN (
    SELECT DISTINCT ON (ce.contract_id)
        ce.contract_id, ce.description, ce.created, cet.title, cet.id
    FROM contract_events ce
    JOIN contract_event_types cet 
        ON cet.id = ce.contract_event_type_id
    WHERE cet.id IN (10, 106)
    ORDER BY ce.contract_id, ce.created DESC
) AS cet_filtrado 
    ON cet_filtrado.contract_id = c.id
JOIN contract_types AS cttt ON cttt.id = c.contract_type_id
LEFT JOIN (
    SELECT DISTINCT ON (cst2.contract_id)
        ai2.protocol AS protocolo_retirada,
        it2.title AS tipo_retirada,
        cst2.contract_id
    FROM assignments AS a2
    JOIN assignment_incidents AS ai2 ON ai2.assignment_id = a2.id
    JOIN incident_types AS it2 ON it2.id = ai2.incident_type_id
    LEFT JOIN contract_service_tags cst2 ON cst2.id = ai2.contract_service_tag_id
    WHERE 
        it2.id IN (1972,1961,2509,2460,2374,2065,1387,1484,1560,1642,1385,1151,1291,1015,1271)
        AND ai2.incident_status_id NOT IN (3,4,8)
    ORDER BY cst2.contract_id, ai2.protocol
) AS retirada
    ON retirada.contract_id = c.id 
LEFT JOIN (
    SELECT DISTINCT ON (ai3.protocol)
        ai3.protocol AS protocolo_reativacao,
        a3.description AS relato_abertura_reativacao,
        DATE(a3.created) AS data_abertura_reativacao,
        it3.title AS tipo_reativacao,
        cst3.contract_id,
        (SELECT ss.title FROM solicitation_service_categories ss WHERE ss.id = ssc3.service_category_id_4) AS cat_4,
        (SELECT ss.title FROM solicitation_service_categories ss WHERE ss.id = ssc3.service_category_id_5) AS cat_5
    FROM assignments AS a3
    JOIN assignment_incidents AS ai3 ON ai3.assignment_id = a3.id
    JOIN incident_types AS it3 ON it3.id = ai3.incident_type_id
    LEFT JOIN contract_service_tags cst3 ON cst3.id = ai3.contract_service_tag_id
    LEFT JOIN solicitation_category_matrices ssc3 ON ssc3.id = ai3.solicitation_category_matrix_id
    WHERE 
        it3.id IN (1563,2184,2185,2186,2542,2543,2544,2461,2479,2480,2400,2401,2402,2403,2304,2305,2306,2307,1014,1905,1906,1907,1204,1723,1205,1724,1927)
    ORDER BY ai3.protocol, cst3.contract_id
) AS reativacao
    ON reativacao.contract_id = c.id
    AND DATE(reativacao.data_abertura_reativacao) >= DATE(cet_filtrado.created)
LEFT JOIN contract_service_tags cat_pat ON cat_pat.contract_id = c.id
LEFT JOIN patrimony_packing_lists pp_pat ON pp_pat.contract_service_tag_id = cat_pat.id
LEFT JOIN patrimony_packing_list_items ppli_pat ON ppli_pat.patrimony_packing_list_id = pp_pat.id
LEFT JOIN patrimonies pat ON pat.id = ppli_pat.patrimony_id
LEFT JOIN contract_eventual_values AS cev ON cev.contract_id = c.id AND cev.deleted = FALSE AND DATE (cev.created) >= DATE (cet_filtrado.created)

WHERE
    it.id IN (1226, 2168, 1180, 2148)
    AND DATE(a.conclusion_date) BETWEEN '$data01' AND '$data02'