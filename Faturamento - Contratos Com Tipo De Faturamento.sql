SELECT 

ct.contract_number AS numero_contrato,
(SELECT p.name FROM people AS p WHERE p.id = ct.client_id) AS cliente,
(SELECT ctt.title FROM contract_types AS ctt WHERE ctt.id = ct.contract_type_id) AS tipo_contrato,
ct.v_status AS status_contrato,
ct.v_invoice_type AS tipo_faturamento

FROM contracts AS ct

WHERE 

ct.v_status != 'Cancelado' 
AND ct.deleted = FALSE 