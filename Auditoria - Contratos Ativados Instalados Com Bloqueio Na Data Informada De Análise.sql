WITH contratos_abril AS (
	SELECT DISTINCT ON (c.id)
		c.id,
		c.client_id,
		c.seller_1_id,
		c.created_by,
		c.company_place_id,
		c.contract_type_id,
		c.v_status,
		c.v_stage,
		ac.service_product_id AS ac_service_product_id,
		ci.service_product_id AS ci_service_product_id,
		ppg.people_group_id,
		CASE
			WHEN caa.activation_date IS NULL THEN DATE(a.conclusion_date)
			ELSE DATE(caa.activation_date)
		END AS data_ativacao
	FROM
		contracts AS c
		JOIN people AS p ON p.id = c.client_id
		JOIN assignments AS a ON a.requestor_id = p.id
		JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
		LEFT JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
		LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
		LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
		LEFT JOIN contract_items AS ci ON ci.contract_id = c.id
	WHERE
		(
			c.v_stage IN ('Em Aprovação', 'Pré-Contrato')
			AND c.deleted = FALSE
			AND p.name NOT LIKE '%Teste%'
			AND c.v_status != 'Cortesia'
			AND c.contract_type_id NOT IN (4, 6, 13, 19, 8, 9)
			AND c.created_by NOT IN (88, 94, 101, 10, 56)
			AND c.id IN (
				SELECT c.id
				FROM contracts AS c
				JOIN people AS p ON p.id = c.client_id
				JOIN assignments AS a ON a.requestor_id = p.id
				JOIN assignment_incidents AS ai ON ai.assignment_id = a.id
				WHERE
					ai.incident_status_id = 4
					AND ai.incident_type_id IN (1005,1006,1901,1899,1900,2271,2331,2288,2332,2388,2389,2390,2391,2482,2500,2498,2534,2535,2536)
					AND DATE(a.conclusion_date) >= DATE(c.created)
					AND DATE(a.conclusion_date) BETWEEN '2026-04-01' AND '2026-04-30'
			)
			AND ai.incident_status_id = 4
			AND ai.incident_type_id IN (1005,1006,1901,1899,1900,2271,2331,2288,2332,2388,2389,2390,2391,2482,2500,2498,2534,2535,2536)
			AND DATE(a.conclusion_date) >= DATE(c.created)
			AND DATE(a.conclusion_date) BETWEEN '2026-04-01' AND '2026-04-30'
		)
		OR
		(
			caa.activation_date BETWEEN '2026-04-01' AND '2026-04-30'
			AND c.v_status != 'Cortesia'
			AND c.contract_type_id NOT IN (4, 6, 13, 19, 8, 9)
			AND c.created_by NOT IN (88, 94, 101, 10, 56)
		)
	ORDER BY c.id, caa.activation_date DESC NULLS LAST
),

ultimo_evento AS (
	SELECT DISTINCT ON (ce.contract_id)
		ce.contract_id,
		cet.title AS ultimo_evento
	FROM contract_events AS ce
	JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
	WHERE
		ce.contract_id IN (SELECT id FROM contratos_abril)
		AND ce.created <= '2026-05-10 23:59:59' -- Informar a data de análise aqui
		AND cet.title ILIKE ANY (ARRAY[
			'Bloqueio Financeiro',
			'Bloqueio Administrativo',
			'Bloqueio Retenção',
			'Aviso de Bloqueio',
			'Suspensão de Contrato',
			'Inadimplência',
			'Cancelamento de Contrato',
			'Cancelamento - Contrato',
			'Cancelamento Inadimplente',
			'Cancelamento em Lote',
			'Desbloqueio Financeiro',
			'Desbloqueio de conexão',
			'Reativação de Contrato',
			'Cancelamento Revertido'
		])
	ORDER BY ce.contract_id, ce.created DESC
)

SELECT
	ca.id,
	(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
	p.name AS cliente,
	CASE
		WHEN ca.ac_service_product_id IS NULL THEN (SELECT serv.huawei_profile_name FROM service_products AS serv WHERE serv.id = ca.ci_service_product_id)
		ELSE (SELECT serv.huawei_profile_name FROM service_products AS serv WHERE serv.id = ca.ac_service_product_id)
	END AS plano,
	CASE
		WHEN ca.ac_service_product_id IS NULL THEN (SELECT serv.selling_price FROM service_products AS serv WHERE serv.id = ca.ci_service_product_id)
		ELSE (SELECT serv.selling_price FROM service_products AS serv WHERE serv.id = ca.ac_service_product_id)
	END AS valor_plano,
	CASE
		WHEN ca.seller_1_id IS NULL THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = ca.created_by)
		ELSE (SELECT p2.name FROM people AS p2 WHERE p2.id = ca.seller_1_id)
	END AS vendedor_1,
	CASE
		WHEN ca.people_group_id IS NULL THEN 'Sem Vendedor'
		ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ca.people_group_id)
	END AS equipe,
	ca.data_ativacao,
	(SELECT emp.description FROM companies_places AS emp WHERE emp.id = ca.company_place_id) AS empresa,
	ca.v_status AS status_contrato_atual,
	(SELECT ct.title FROM contract_types AS ct WHERE ct.id = ca.contract_type_id) AS tipo_contrato,
	ue.ultimo_evento AS status_na_data_analisada
FROM
	contratos_abril AS ca
	JOIN people AS p ON p.id = ca.client_id
	JOIN ultimo_evento AS ue ON ue.contract_id = ca.id 
WHERE
	ue.ultimo_evento IN (
		'Bloqueio Financeiro',
		'Bloqueio Administrativo',
		'Bloqueio Retenção',
		'Aviso de Bloqueio',
		'Suspensão de Contrato',
		'Inadimplência',
		'Cancelamento de Contrato',
		'Cancelamento - Contrato',
		'Cancelamento Inadimplente',
		'Cancelamento em Lote'
	)
ORDER BY ca.id