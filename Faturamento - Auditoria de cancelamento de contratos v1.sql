SELECT DISTINCT ON (cst.contract_id)
	 ai.protocol AS protocolo,
    (SELECT p.name FROM people AS p WHERE p.id = a.requestor_id) AS cliente,
    c.amount AS valor_contrato,
    cst.service_tag AS tag_contrato,
    cst.description AS etiqueta,
    (SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS empresa,
    c.collection_day AS vencimento,
    c.v_status AS status_contrato,
    (SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_4) AS cat_4_cancelamento,
    (SELECT ss.title from solicitation_service_categories AS ss WHERE ss.id = ssc.service_category_id_5) AS cat_5_cancelamento,
    COUNT (fatr.id) AS faturas_pagas

        FROM assignments AS a
        JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
        LEFT JOIN contract_service_tags AS cst ON cst.id = ai.contract_service_tag_id
        JOIN contracts AS c ON c.id = cst.contract_id
        LEFT JOIN  financial_receivable_titles AS fat ON fat.client_id = c.client_id
		  LEFT JOIN financial_receipt_titles AS fatr ON fat.id = fatr.financial_receivable_title_id and fatr.deleted = FALSE  AND ( fat.title LIKE '%FAT%' 	OR (fat.origin IN (1, 3, 4, 7, 11) AND fatr.receipt_origin_id IS NULL))
		  LEFT join solicitation_category_matrices AS ssc ON ssc.id = ai.solicitation_category_matrix_id
      
WHERE 
	 ai.incident_type_id IN (1442,1984)
    AND DATE(a.conclusion_date) BETWEEN '2025-02-01' AND '2025-02-10'
    AND ai.incident_status_id = 4 
    
    GROUP BY cst.contract_id, 1,2,3,4,5,6,7,8,9,10