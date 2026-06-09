SELECT --DISTINCT ON (ct.id)

ct.id AS id_contrato,
DATE (ct.created) AS data_criacao_contrato,
DATE (ce.created) AS data_evento_cancelamento,
p.name AS cliente,
p.city AS cidade_cliente,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS local_contrato,
ctt."description" AS tipo_contrato,
cet.title AS evento,
--DATE (ce.created) AS data_evento,
--ct.v_status AS status,
ct.amount AS valor_contrato,
ci."description" AS plano,
(SELECT v.name FROM v_users AS v WHERE v.id = ce.created_by) AS responsavel


FROM contracts AS ct
LEFT JOIN contract_events AS ce ON ce.contract_id = ct.id
LEFT JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
LEFT JOIN people AS p ON p.id = ct.client_id
LEFT JOIN contract_items AS ci ON ci.contract_id = ct.id
LEFT JOIN service_products AS sp ON sp.id = ci.service_product_id
LEFT JOIN contract_types AS ctt ON ctt.id = ct.contract_type_id


WHERE

DATE (ce.created) BETWEEN '2026-01-01' AND '2026-05-30'
AND cet.id = 184
--AND ct.id = 81684
and ci.p_is_billable = TRUE
AND sp.id NOT IN (3591,3801,3592,6199,5525,5526,6200,3802,5527,5528,2761,6169,6170,2762,6366,6367,45,6327,6092,6602)
--AND sp.huawei_profile_name IS NOT NULL 
AND ct.contract_type_id IN (35,36,37,38,39,45)



