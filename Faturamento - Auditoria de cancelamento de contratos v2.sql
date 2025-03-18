WITH cancelamentos AS (
    SELECT 
        cst.contract_id,
        a.created AS created_cancelamento,
        ai.protocol AS protocolo,
        (SELECT p.name FROM people p WHERE p.id = a.requestor_id) AS cliente,
        c.amount AS valor_contrato,
        cst.service_tag AS tag_contrato,
        cst.description AS etiqueta,
        (SELECT cp.description FROM companies_places cp WHERE cp.id = c.company_place_id) AS empresa,
        c.collection_day AS vencimento,
        CASE 
    			WHEN c.discount_use_contract = 1 THEN 'Conforme Contrato'
    			WHEN c.discount_use_contract = 0 THEN 'Conforme Tipo De Cobrança'
    			WHEN c.discount_use_contract = 2 THEN 'Não Aplica Desconto'
   	  END AS possui_desconto_no_contrato,
        c.v_status AS status_contrato,
        c.observation AS observacoes,
        (SELECT it.title FROM incident_types it WHERE it.id = ai.incident_type_id) AS tipo_solicitacao,
        a.description AS texto_abertura,
        (SELECT p.name FROM people AS p WHERE p.id = a.responsible_id) AS responsalvel,
        (SELECT ins.title FROM incident_status AS ins WHERE ins.id = ai.incident_status_id) AS status_solicitacao,
        (SELECT ss.title FROM solicitation_service_categories ss WHERE ss.id = ssc.service_category_id_4) AS cat_4_cancelamento,
        (SELECT ss.title FROM solicitation_service_categories ss WHERE ss.id = ssc.service_category_id_5) AS cat_5_cancelamento,
		  LAST_VALUE(cet.title) OVER (PARTITION BY c.id ORDER BY ce.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS evento_cancelamento,
		  (SELECT ce_bloq.created FROM contract_events ce_bloq JOIN contract_event_types cett_bloq ON ce_bloq.contract_event_type_id = cett_bloq.id
		   WHERE cett_bloq.title LIKE '%Bloqueio Financeiro%' AND ce_bloq.contract_id = c.id ORDER BY ce_bloq.created DESC LIMIT 1) AS ultimo_evento_bloqueio,
			(SELECT ce_bloq.created FROM contract_events ce_bloq JOIN contract_event_types cett_bloq ON ce_bloq.contract_event_type_id = cett_bloq.id
			WHERE cett_bloq.title LIKE '%Desbloqueio Financeiro%' AND ce_bloq.contract_id = c.id ORDER BY ce_bloq.created DESC LIMIT 1) AS ultimo_evento_desbloqueio,
			a.created AS data_abertura,
			a.conclusion_date AS data_encerramento
			FROM assignments a
			JOIN assignment_incidents ai ON ai.assignment_id = a.id
			LEFT JOIN contract_service_tags cst ON cst.id = ai.contract_service_tag_id
			JOIN contracts c ON c.id = cst.contract_id
			LEFT JOIN solicitation_category_matrices ssc ON ssc.id = ai.solicitation_category_matrix_id
			LEFT JOIN contract_events ce ON ce.contract_id = c.id
			JOIN contract_event_types cet ON cet.id = ce.contract_event_type_id
			WHERE 
			    ai.incident_type_id IN (1442,1984)
			    AND DATE(a.conclusion_date) BETWEEN '2025-03-11' AND '2025-03-11'
			    AND ai.incident_status_id = 4
			    AND cet.title LIKE '%Cancelamento%'
                ),
                faturas AS (
                    SELECT 
                        cst.contract_id,
                        COUNT(fatr.id) AS faturas_pagas
                    FROM assignments a
                    JOIN assignment_incidents ai ON ai.assignment_id = a.id
                    LEFT JOIN contract_service_tags cst ON cst.id = ai.contract_service_tag_id
                    JOIN contracts c ON c.id = cst.contract_id
                    LEFT JOIN financial_receivable_titles fat ON fat.client_id = c.client_id
                    LEFT JOIN financial_receipt_titles fatr ON fat.id = fatr.financial_receivable_title_id AND fatr.deleted = FALSE AND (fat.title LIKE '%FAT%' OR (fat.origin IN (1,3,4,7,11) AND fatr.receipt_origin_id IS NULL))
                    WHERE 
                        ai.incident_type_id IN (1442,1984)
                        AND DATE(a.conclusion_date) BETWEEN '2025-03-11' AND '2025-03-11'
                        AND ai.incident_status_id = 4
                    GROUP BY 
                        cst.contract_id
                    ),
                    outras_solicitacoes AS (
                        SELECT 
                            cst.contract_id,
                            a.created AS created_outro,
                            (SELECT it.title FROM incident_types it WHERE it.id = ai.incident_type_id) AS solicitacao_desautenticar,
                            ai.protocol AS protocolo_desautenticar
                        FROM assignments a
                        JOIN assignment_incidents ai ON ai.assignment_id = a.id
                        LEFT JOIN contract_service_tags cst ON cst.id = ai.contract_service_tag_id
                        JOIN contracts c  ON c.id = cst.contract_id
                        WHERE 
                            ai.incident_type_id IN (1569, 2093)
                            AND DATE(a.created) BETWEEN '2025-03-11' AND '2025-03-11'
                            --AND ai.incident_status_id = 4
)

SELECT DISTINCT ON (c.contract_id)
       c.contract_id,
       c.protocolo,
       c.cliente,
       c.valor_contrato,
       c.tag_contrato,
       c.etiqueta,
       c.empresa,
       c.vencimento,
       f.faturas_pagas,
       c.possui_desconto_no_contrato,
       c.status_contrato,
       c.observacoes,
       c.tipo_solicitacao,
       c.texto_abertura,
       c.responsalvel,
       c.status_solicitacao,
       c.cat_4_cancelamento,
       c.cat_5_cancelamento,
       c.evento_cancelamento,
       c.ultimo_evento_bloqueio,
       c.ultimo_evento_desbloqueio,
       c.data_abertura,
       c.data_encerramento,
       o.solicitacao_desautenticar,
       o.protocolo_desautenticar

FROM cancelamentos c
LEFT JOIN faturas f ON f.contract_id = c.contract_id
LEFT JOIN outras_solicitacoes o ON o.contract_id = c.contract_id AND o.created_outro >= c.created_cancelamento
ORDER BY 
    c.contract_id, 
    c.created_cancelamento DESC;