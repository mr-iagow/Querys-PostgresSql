SELECT 
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS empresa,
ct.id AS id_contrato,
p.name AS cliente,
p.tx_id AS documento,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = ct.financial_collection_type_id) AS tipo_cobranca,
(SELECT cy.title FROM contract_types AS cy WHERE cy.id = ct.contract_type_id) AS tipo_contrato


FROM contracts AS ct 
JOIN people AS p ON p.id = ct.client_id


WHERE 

ct.financial_collection_type_id IN (54, 57, 25, 64, 66, 27, 58, 56, 59, 77, 62, 61, 60, 55, 65, 75, 76, 74, 63, 26, 85, 88, 86, 87)
 AND  ct.v_status != 'Cancelado'
  AND ct.v_status != 'Encerrado'
  AND ct.v_stage = 'Aprovado'