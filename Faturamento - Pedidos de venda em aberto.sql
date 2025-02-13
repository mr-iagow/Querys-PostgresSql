SELECT DISTINCT ON (sr.id)

sr.id AS id_pedido,
sr.contract_id AS id_contrato,
(SELECT p.name FROM people AS p WHERE p.id = sr.client_id) AS cliente,
(SELECT v.name FROM v_users AS v WHERE v.id = sr.created_by) AS criado_por,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = sr.financial_collection_type_id) AS tipo_cobranca,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = sr.financer_nature_id) AS natureza,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = sr.company_place_id) AS empresa,
sr.total_amount AS valor_total,
DATE (sr.created) AS data_criacao,
sr.observation AS observacao,
sr.motive AS motivo,
(select pf.title from payment_forms as pf where pf.id = sr.payment_form_id) AS forma_pagamento,
(select fo.title from financial_operations as fo where fo.id = sr.financial_operation_id) AS operacao,

CASE 
WHEN sr.deleted =  FALSE THEN 'Nao'
WHEN sr.deleted = TRUE THEN 'Sim'
END AS deletado,
(SELECT t.title FROM teams AS t WHERE t.id = vu.team_id) AS equipe_usuario



FROM sale_requests AS sr
LEFT JOIN v_users AS vu ON vu.id = sr.created_by


WHERE 

sr.situation = 2
--AND sr.contract_id IS NOT NULL 
and sr.deleted = false

