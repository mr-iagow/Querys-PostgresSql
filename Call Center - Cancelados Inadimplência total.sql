SELECT DISTINCT ON (ce.id)

ct.id AS id_contrato,
p.id,
DATE (ct.created) AS data_criacao_contrato,
p.name AS cliente,
p.city AS cidade_cliente,
p.neighborhood AS bairro,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS local_contrato,
cet.title AS evento,
DATE (ce.created) AS data_evento,
ct.v_status AS status,
ct.amount AS valor_contrato,
(SELECT v.name FROM v_users AS v WHERE v.id = ce.created_by) AS responsavel,
ci."description" AS plano,
CASE WHEN ct.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = ct.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = ct.seller_1_id) END AS vendedor_1,
ct.beginning_date AS data_inicial_fidelidade,
FIRST_VALUE(pu.begin) OVER (PARTITION BY ct.client_id) AS arquivo_fidelidade_mais_recente,
(SELECT 

COUNT ( distinct frt.id)

FROM financial_receipt_titles AS frt
JOIN financial_receivable_titles AS frtt ON frtt.id = frt.financial_receivable_title_id

WHERE frt.client_id = p.id AND frtt.title LIKE '%FAT%' AND FRTT.DELETED = FALSE) AS qtd_paga



FROM contracts AS ct
LEFT JOIN contract_events AS ce ON ce.contract_id = ct.id
LEFT JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN people AS p ON p.id = ct.client_id
LEFT JOIN contract_items AS ci ON ci.contract_id = ct.id
LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id 
LEFT JOIN financial_receipt_titles AS frt ON frt.client_id = p.id


WHERE

DATE (ce.created) BETWEEN '2024-08-01' AND '2024-08-31'
AND cet.id = 184
--AND ct.id = 81684
and ci.p_is_billable = TRUE
AND sp.id NOT IN (3591,3801,3592,6199,5525,5526,6200,3802,5527,5528,2761,6169,6170,2762,6366,6367,45,6327,6092,6602)
--AND sp.huawei_profile_name IS NOT NULL 

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,pu."begin",ce.id



