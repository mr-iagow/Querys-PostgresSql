WITH w_internal_use_persons AS (

SELECT ppmv.company_place_id,

ppmv.service_product_id,

COALESCE(sum(ppmv.balance), 0::numeric) AS balance

FROM person_product_movimentation_view ppmv

GROUP BY ppmv.company_place_id, ppmv.service_product_id

), w_internal_use_patrimonies AS (

SELECT pat.service_product_id,

pat.company_place_id,

count(pat.id) AS balance

FROM patrimonies pat

WHERE NOT pat.return_pending AND pat.person_id IS NOT NULL

GROUP BY pat.company_place_id, pat.service_product_id

), w_internal_use_structure_patrimonies AS (

SELECT pat.service_product_id,

pat.company_place_id,

count(pat.id) AS balance

FROM patrimonies pat

WHERE pat.authentication_access_point_id IS NOT NULL OR pat.authentication_site_id IS NOT NULL

GROUP BY pat.company_place_id, pat.service_product_id

), w_products_in_solicitations AS (

SELECT a.company_place_id,

a.service_product_id,

COALESCE(sum(a.units), 0::numeric) AS balance

FROM person_product_movimentations a

WHERE a.assignment_id IS NOT NULL AND a.invoice_note_id IS NULL AND a.signal = 2

GROUP BY a.service_product_id, a.company_place_id

), w_patrimonies_in_solicitations AS (

SELECT a.company_place_id,

a.service_product_id,

count(1) AS balance

FROM patrimonies a

JOIN patrimony_packing_list_items b ON a.id = b.patrimony_id

JOIN patrimony_packing_lists c ON b.patrimony_packing_list_id = c.id

WHERE a.client_id IS NOT NULL AND c.assignment_id IS NOT NULL AND b.out_invoice_note_id IS NULL AND b.returned = 0

GROUP BY a.service_product_id, a.company_place_id

), w_reserved_in_sale_request AS (

SELECT a.service_product_id,

b.company_place_id,

sum(a.number) AS balance

FROM sale_request_items a

JOIN sale_requests b ON a.sale_request_id = b.id

JOIN service_products c ON a.service_product_id = c.id

LEFT JOIN patrimonies d ON a.patrimony_id = d.id

WHERE (b.situation = ANY (ARRAY[1::bigint, 2::bigint, 6::bigint, 7::bigint])) AND NOT b.deleted

GROUP BY b.company_place_id, a.service_product_id

), w_pending_return_products AS (

SELECT a.service_product_id,

a.company_place_id,

COALESCE(sum(a.units), 0::numeric) AS balance

FROM person_product_movimentations a

WHERE a.return_pending

GROUP BY a.company_place_id, a.service_product_id

), 

w_patrimonies_situation_not_normal AS (

	SELECT x.service_product_id,
	x.company_place_id,
	count(*) AS balance
	
	FROM patrimonies x
	
	WHERE x.situation <> 0 AND NOT x.deleted
	
	GROUP BY x.company_place_id, x.service_product_id

)

SELECT
--Select dos itens da consultas
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = bal.company_place_id) AS empresa,
(SELECT sp.title FROM service_products AS sp WHERE sp.id = bal.service_product_id) AS item,
COALESCE(bal.unidades, 0::numeric) - COALESCE(wrisr.balance, 0::numeric) - COALESCE(wprp.balance, 0::numeric) - COALESCE(wpsnn.balance, 0::bigint)::numeric AS "disponivel",
COALESCE(bal.unidades, 0::NUMERIC) AS em_estoque,
COALESCE(wrisr.balance, 0::NUMERIC) AS em_pedidos_venda,
COALESCE(wprp.balance, 0::NUMERIC) AS pendente_retorno,
COALESCE(wpsnn.balance, 0::bigint)::NUMERIC AS situacao_nao_normal,
COALESCE(bal.unidades, 0::NUMERIC) AS "[Saldo Inicial + Movimentacoes (Entradas e Saidas)]",
COALESCE(wrisr.balance, 0::numeric) AS "Pat. Reservados em Pedidos de Venda",
COALESCE(wprp.balance, 0::numeric) AS "Pendentes de Retorno",
COALESCE(wpsnn.balance, 0::bigint) AS "Pat com Situacao Diferente de Normal"


--Joins da consulta
FROM v_new_service_products_company_balances bal
JOIN service_products pro ON pro.id = bal.service_product_id
LEFT JOIN w_internal_use_persons wiup ON wiup.service_product_id = bal.service_product_id AND wiup.company_place_id = bal.company_place_id
LEFT JOIN w_internal_use_patrimonies wiupat ON wiupat.service_product_id = bal.service_product_id AND wiupat.company_place_id = bal.company_place_id
LEFT JOIN w_internal_use_structure_patrimonies wiusp ON wiusp.service_product_id = bal.service_product_id AND wiusp.company_place_id = bal.company_place_id
LEFT JOIN w_products_in_solicitations wpis ON wpis.service_product_id = bal.service_product_id AND wpis.company_place_id = bal.company_place_id
LEFT JOIN w_patrimonies_in_solicitations wpais ON wpais.service_product_id = bal.service_product_id AND wpais.company_place_id = bal.company_place_id
LEFT JOIN w_reserved_in_sale_request wrisr ON wrisr.service_product_id = bal.service_product_id AND wrisr.company_place_id = bal.company_place_id
LEFT JOIN w_pending_return_products wprp ON wprp.service_product_id = bal.service_product_id AND wprp.company_place_id = bal.company_place_id
LEFT JOIN w_patrimonies_situation_not_normal wpsnn ON wpsnn.service_product_id = bal.service_product_id AND wpsnn.company_place_id = bal.company_place_id

WHERE 
bal.company_place_id = 5