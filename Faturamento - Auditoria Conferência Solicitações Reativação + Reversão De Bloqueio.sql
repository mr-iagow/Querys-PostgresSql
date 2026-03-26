SELECT DISTINCT ON (ai.protocol)
p.name AS cliente,
it.title AS tipo_solicitacao,
cst.service_tag AS tag_contrato,
cst.description AS etiqueta,
c.contract_number AS numero_contrato,
c.v_status AS status_contrato,
c.collection_day AS dia_vencimento_contrato,
c.beginning_date AS vigencia_inicial_contrato,
c.final_date AS vigencia_final_contrato,
c.billing_beginning_date AS faturar_inicial_contrato,
c.billing_final_date AS faturar_final_contrato,
c.observation AS observacoes_contrato,
c.amount AS valor_contrato,
(SELECT serv.title FROM service_products AS serv WHERE serv.id = ac.service_product_id) AS plano_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.second_financial_operation_id) AS operacao_secundaria_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca_contrato,
(SELECT op.title FROM financial_operations AS op WHERE op.id = ag.financial_operation_id) AS operacao_agrupador,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS nautreza_agrupador,
(SELECT fn3.title FROM financial_collection_types AS fn3 WHERE fn3.id = ag.financial_collection_type_id) AS tipo_cobranca_agrupador,
cet_filtrado.title AS tipo_evento,
CASE 
	WHEN cet_filtrado.id IN ( 10, 106 )
   	AND DATE(cet_filtrado.created) >= DATE(a.conclusion_date)
   	THEN 'Sim'
      ELSE 'Não'
END AS tem_evento_no_contrato,
CASE 
	WHEN cet_filtrado.id IN ( 10, 106 ) AND DATE(cet_filtrado.created) >= DATE(a.conclusion_date)
   	THEN cet_filtrado.created 
      ELSE null
END AS data_evento_no_contrato,
last_VALUE(pu.begin) OVER (PARTITION BY c.client_id) AS arquivo_fidelidade_mais_recente,
ai.protocol AS protocolo,
a.description AS relato_abertura,
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_3) AS cat_3, 
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4, 
(SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5, 
v.name AS responsavel_abertura,
DATE (a.created) AS data_abertura,
DATE (a.conclusion_date) AS data_encerramento,
pp.name AS responsavel_encerramento,
ins.title AS status_solicitacao


FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
JOIN incident_types AS it ON it.id = ai.incident_type_id
LEFT JOIN contract_service_tags cst ON cst.id = ai.contract_service_tag_id
JOIN contracts c ON c.id = cst.contract_id
JOIN people AS p ON p.id = a.requestor_id
JOIN incident_status AS ins ON ins.id = ai.incident_status_id
JOIN people AS pp ON pp.id = a.responsible_id
JOIN v_users AS v ON v.id = a.created_by
INNER JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
INNER JOIN contract_items AS serv ON ag.id = serv.contract_configuration_billing_id AND serv.deleted = FALSE
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id 
LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN (
    SELECT ce.contract_id, ce.description, ce.created, cet.title, cet.id
    FROM contract_events ce
    JOIN contract_event_types cet 
        ON cet.id = ce.contract_event_type_id
    WHERE cet.id IN ( 10, 106 )
) AS cet_filtrado 
    ON cet_filtrado.contract_id = c.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id


WHERE
    it.id IN (1226, 2168, 1180, 2148)
    AND DATE(a.conclusion_date) BETWEEN '$data01' AND '$data02'