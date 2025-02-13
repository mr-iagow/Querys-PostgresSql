SELECT DISTINCT ON (cst.contract_id)
    (SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
    cst.service_tag AS tag_contrato,
    cst.description AS etiqueta,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
    c.collection_day AS vencimento,
    c.cut_day AS dia_corte,
    CASE 
    	WHEN c.discount_use_contract = 1 THEN 'Conforme Contrato'
    	WHEN c.discount_use_contract = 0 THEN 'Conforme Tipo De Cobrança'
    	WHEN c.discount_use_contract = 2 THEN 'Não Aplica Desconto'
    END AS possui_desconto_no_contrato,
    c.v_status AS status_contrato,
    c.observation AS observacoes_contrato,    
    LAST_VALUE(frt.expiration_date) OVER (PARTITION BY frt.contract_id  ORDER BY frt.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ultima_fatura_gerada,
        (DATE(a.created) - DATE(fat_last.expiration_date)) AS dias_plano_antigo,
    trunc((replace(regexp_replace(trim(array_to_string(regexp_match(
                LAST_VALUE(ce.description) OVER (PARTITION BY cst.contract_id  ORDER BY ce.created 
                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),'Total:([^|]+)'),'')),'[^0-9,]','','g'),',', '.')::numeric / 30
    ) * (DATE(a.created) - DATE(fat_last.expiration_date)),2 ) AS valor_plano_antigo,
    last_VALUE(pu.begin) OVER (PARTITION BY c.client_id) AS arquivo_fidelidade_mais_recente,
    (SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
    (SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
    (SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca,
    LAST_VALUE(op.title) OVER (PARTITION BY ag.contract_id  ORDER BY ag.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS operacao_agrupador,
    LAST_VALUE(fn.title) OVER (PARTITION BY ag.contract_id  ORDER BY ag.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS natureza_agrupador,
    LAST_VALUE(fct.title) OVER (PARTITION BY ag.contract_id  ORDER BY ag.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS tipo_cobranca_agrupador,
    ai.protocol AS protocolo,
    (SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
    a.description AS descricao_abertura,
    (SELECT ss.title FROM solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS necessario_troca, 
    (SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
    (SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsalvel,
    a.conclusion_date AS data_encerramento_os,
    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ), 'Serviço Incluído: ([^|]+)'
        ), ''
    ) AS plano_incluido,
    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ), 'Val. Unitário:([^|]+)'
        ), ''
    ) AS valor_plano_incluido,
    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ), 'Serviço Excluído: ([^|]+)'
        ), ''
    ) AS plano_excluido,
            array_to_string(
                regexp_match(
                    LAST_VALUE(ce.description) OVER (
                        PARTITION BY cst.contract_id  
                        ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                    ),
                    '(?s)Serviço Excluído:.*Total:(R\$[0-9]+,[0-9]{2})[[:space:]]+Justificativa:' --para corrigir a abertura do $ na consulta
                ),
                ''
            ) AS valor_plano_excluido,

    array_to_string(
        regexp_match(
            LAST_VALUE(ce.description) OVER (
                PARTITION BY cst.contract_id  
                ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ), 'Justificativa: (.+)'
        ), ''
    ) AS justificativa
    
        FROM assignments AS a
        JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
        LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
        JOIN contracts AS c ON c.id = cst.contract_id
        JOIN v_users AS v ON v.id = a.created_by
        LEFT JOIN contract_events AS ce ON ce.contract_id = c.id
        JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
        LEFT JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
        JOIN people AS p ON p.id = c.client_id
        LEFT JOIN people_uploads AS pu ON pu.people_id = p.id 
        LEFT JOIN solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
        LEFT JOIN solicitation_category_matrix_solutions AS scms ON scms.solicitation_category_matrix_id = ssc.id
        LEFT JOIN financial_receivable_titles AS frt ON frt.contract_id = c.id AND frt.title LIKE '%FAT%'
        LEFT JOIN financial_operations AS op ON op.id = ag.financial_operation_id
        LEFT JOIN financial_collection_types AS fct ON fct.id = ag.financial_collection_type_id
        LEFT join financers_natures AS fn ON fn.id = ag.financer_nature_id

        LEFT JOIN LATERAL (
            SELECT fat2.expiration_date
            FROM financial_receivable_titles fat2
            WHERE fat2.contract_id = c.id
            AND fat2.title LIKE '%FAT%'
            AND fat2.expiration_date < date_trunc('month', a.created)
            ORDER BY fat2.expiration_date DESC
            LIMIT 1
        ) AS fat_last ON true

WHERE 
    ai.incident_type_id IN (1327, 2018, 2156, 2155, 2174, 2222, 2153, 2154, 2157, 2024, 2014, 2016, 1776, 1308, 1397, 1328, 1017, 1821, 1330, 2091, 2124, 2125, 1991, 1992, 1398, 1606, 1822, 2100, 2099, 2101, 1974, 1975, 1604, 1605, 52,51, 2100,1823)
    AND DATE(a.conclusion_date) BETWEEN '$encerramento01' AND '$encerramento02'
    AND cet.id = 133
    AND ce.description LIKE '%Serviço Incluído%'
    AND ai.incident_status_id = 4 