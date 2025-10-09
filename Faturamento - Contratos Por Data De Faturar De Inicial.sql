SELECT 

ct.contract_number AS numero_contrato,
(SELECT p.name FROM people AS p WHERE p.id = ct.client_id) AS cliente,
ct.billing_beginning_date AS data_inicio_faturamento,
(SELECT ctt.title FROM contract_types AS ctt WHERE ctt.id = ct.contract_type_id) AS tipo_contrato,
cp."description" AS empresa,
ct.approval_date AS data_aprovacao,
ct.v_status AS status_contrato

FROM contracts AS ct
JOIN companies_places AS cp ON cp.id = ct.company_place_id

WHERE DATE (ct.billing_beginning_date) >= '2025-12-01'