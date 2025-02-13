SELECT DISTINCT ON (ct.id) 
    ct.id,
    p."name" AS cliente,
    p.city AS cidade,
    p.neighborhood AS bairro,
    ct.cancellation_date AS DataCancelamento,
   (ct.cancellation_date - caa.activation_date) AS qtd_Dias_Ativo,
   cet.title AS motivo_cancelamento,
   ai.protocol AS protocolo


    
FROM contracts AS ct
LEFT JOIN  contract_assignment_activations AS caa ON caa.contract_id = ct.id
JOIN contract_events AS ce ON ce.contract_id = ct.id 
LEFT JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id 
LEFT JOIN people AS p ON p.id = ct.client_id
LEFT JOIN contract_service_tags AS ctag ON ctag.contract_id = ct.id
LEFT JOIN assignment_incidents AS ai ON ai.contract_service_tag_id = ctag.id AND ai.incident_type_id IN ( 1984,1442 )

WHERE 
    ct.cancellation_date BETWEEN '2024-01-01' AND '2024-12-31'
    
AND (ct.cancellation_date - caa.activation_date) BETWEEN 30 AND 90
--AND ct.id = 111519
AND cet.title LIKE '%Cancelamento%'
AND cet.title != 'Cancelamentos Contratos Teste de Sistema'
AND cet.title != 'Cancelamento - Contrato de eventos'
--AND p."name" = 'VIVIANE DA SILVA VIEIRA'