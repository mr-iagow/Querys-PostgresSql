SELECT DISTINCT ON (cst.contract_id)
    (SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
    cst.service_tag AS tag_contrato,
    cst.description AS etiqueta,
    c.collection_day AS vencimento,
    c.v_status AS status_contrato,
    c.observation AS observacoes_contrato,
    LAST_VALUE(fat.competence) OVER (
                PARTITION BY fat.contract_id 
                ORDER BY fat.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS  ultima_competencia_gerada,         
    last_VALUE(pu.begin) OVER (PARTITION BY c.client_id) AS arquivo_fidelidade_mais_recente,
    (SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
	 (SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS nautreza_contrato,
    (SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca,
	 (SELECT op.title FROM financial_operations AS op WHERE op.id = ag.financial_operation_id) AS operacao_agrupador,
	 (SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS nautreza_agrupador,
    ai.protocol AS protocolo,
    (SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
    (SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS necessario_troca, 
    (SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
    (SELECT p.name FROM people AS p WHERE p.id = a.responsible_id ) AS responsalvel,
    a.conclusion_date AS data_encerramento_os,
    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 'Serviço Incluído: ([^|]+)'), '') AS  plano_incluido,
    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 'Val. Unitário:([^|]+)'), '') AS valor_plano_incluido,
    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 'Serviço Excluído: ([^|]+)'), '') AS plano_excluido,
    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 'Total:([^|]+)'), '') AS valor_plano_ecluido,   
        array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 'Justificativa: (.+)'), '') AS justificativa
    
    

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
JOIN contracts AS c ON c.id = cst.contract_id
JOIN v_users AS v ON v.id = a.created_by
LEFT JOIN contract_events AS ce ON ce.contract_id = c.id
JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
left JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
JOIN people AS p ON p.id = c.client_id
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id 
LEFT JOIN financial_receivable_titles AS fat ON fat.contract_id = c.id AND fat.title LIKE '%FAT%'
LEFT join solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id

WHERE 
ai.incident_type_id = 2174
AND DATE (a.conclusion_date) BETWEEN '2025-01-01' AND '2025-01-05'
AND cet.id = 133
AND ce.description LIKE '%Serviço Incluído%'
AND ai.incident_status_id = 4
--ai.protocol = 2771440
--AND ce.description LIKE '%Serviço Incluído%'


