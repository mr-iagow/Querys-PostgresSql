SELECT DISTINCT ON (frt.id)
    p.name AS nome_cliente,
    (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) AS motivo_nao_bloqueio,
    frt.title_amount AS valor_em_aberto,
    (SELECT sp.title FROM service_products AS sp WHERE sp.id = ac.service_product_id) AS plano,
    frt.expiration_date AS data_vencimento_fatura,
    frtt.receipt_date,
    frt.title AS fatura,
    CURRENT_DATE - frt.expiration_date AS dias,
    c.v_status AS status_contrato,
    c.id as cod_contrato,
    LAST_VALUE(ce.description) OVER (
				  PARTITION BY c.id
		        ORDER BY ce.id asc
		        RANGE BETWEEN
		            UNBOUNDED PRECEDING AND
		            UNBOUNDED FOLLOWING
		    ) AS ultimo_evento_contrato,
		   LAST_VALUE(ce.contract_event_type_id) OVER (
			PARTITION BY c.id
		   ORDER BY ce.id asc
		   RANGE BETWEEN
		      UNBOUNDED PRECEDING AND
		      UNBOUNDED FOLLOWING
		    ) AS ultimo_id_evento,
		    
		   LAST_VALUE(ce.created) OVER (
			PARTITION BY c.id
		   ORDER BY ce.id asc
		   RANGE BETWEEN
		      UNBOUNDED PRECEDING AND
		      UNBOUNDED FOLLOWING
		    ) AS data_desbloqueio,
		    
		     frt.expiration_date - 
		   LAST_VALUE(ce.created) OVER (
			PARTITION BY c.id
		   ORDER BY ce.id asc
		   RANGE BETWEEN
		      UNBOUNDED PRECEDING AND
		      UNBOUNDED FOLLOWING
		    )  AS quantidade_dias
		    
		    
		    
		    
    
FROM
    authentication_contracts AS ac
    JOIN contracts AS c ON c.id = ac.contract_id
    JOIN financial_receivable_titles AS frt ON frt.contract_id = c.id
    left JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
    JOIN people AS p ON p.id = c.client_id
    LEFT join person_people_groups AS ppg ON ppg.person_id = p.id
    JOIN contract_events AS ce ON ce.contract_id = c.id AND ce.contract_event_type_id IN (41)
    
WHERE 
    c.contract_type_id NOT IN (6,7,16)
    AND c.v_status = 'Normal'
    --AND frt.created >='2024-09-01'
    AND frt.title LIKE '%FAT%'
   AND frtt.receipt_date IS null
   AND CURRENT_DATE - frt.expiration_date > 10
   AND frt.p_is_receivable = true
   AND frt.deleted = FALSE 


