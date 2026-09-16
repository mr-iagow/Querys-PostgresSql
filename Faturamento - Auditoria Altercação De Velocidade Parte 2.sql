    SELECT DISTINCT ON (cst.contract_id,cev.id)
    p.name AS nome_cliente,
    c.contract_number AS numero_contrato,
    ai.protocol AS protocolo_solicitacao,
    p2.name AS responsavel_protocolo,
    DATE(a.created) AS data_abertura_solicitacao,
    DATE(a.conclusion_date) AS data_encerramento_solicitacao,
    it.title AS tipo_solicitacao,
    DATE (cev.created) AS data_criacao_eventual,
    v.name AS usuario_criador_eventual,
    CASE 
    	WHEN cev."type" = 1 THEN 'Acréscimo'
    	ELSE 'Desconto'
    END AS tipo_eventual,
    cev.total_amount AS valor_eventual,
    cev.month_year AS competencia_eventual,
    cev.justification AS justificativa_criacao_eventual
    
    FROM assignments AS a
    JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
    JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
    JOIN contracts AS c ON c.id = cst.contract_id
    JOIN people AS p ON p.id = a.requestor_id
    JOIN incident_types AS it ON it.id = ai.incident_type_id
    LEFT JOIN contract_eventual_values AS cev 
	 												ON cev.deleted = FALSE
	 												AND cev.contract_id = c.id
	 												AND cev.created >= date_trunc('day', a.conclusion_date)
	 LEFT JOIN v_users AS v ON v.id = cev.created_by
	 LEFT JOIN people AS p2 ON p2.id = a.responsible_id
    WHERE ai.incident_status_id = 4
        AND ai.incident_type_id IN (
            1327, 2018, 2156, 2155, 2174, 2222, 2153, 2154, 2157, 2024,
            2014, 2016, 1776, 1308, 1397, 1328, 1017, 1821, 1330, 2091,
            2124, 2125, 1991, 1992, 1398, 1606, 1822, 2100, 2099, 2101,
            1974, 1975, 1604, 1605, 52, 51, 1823, 2274, 2273, 2275,
            2508, 2650, 2651, 2652)
AND a.conclusion_date >= '2026-08-01'
AND a.conclusion_date < '2026-08-05'
--AND c.id= 83726

ORDER BY cst.contract_id,cev.id, a.conclusion_date DESC NULLS LAST, a.id DESC