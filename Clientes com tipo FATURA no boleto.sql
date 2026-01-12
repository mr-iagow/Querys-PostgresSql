SELECT DISTINCT ON (frt.id)
		c.id AS id_contrato,
		p.name AS nome_cliente, 
		CASE WHEN p.type_tx_id = 1 THEN 'CNPJ' WHEN p.type_tx_id != 1 THEN 'CPF' END AS tipo_cliente,
		frt.title AS titulo_fatura,
		frt.title_amount AS valor_fatura,
		DATE (frt.created) data_emissao,
		frt.expiration_date AS data_vencimento,
		(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id) AS local_contrato,
		c.v_status AS status_contrato,
		(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = frt.financer_nature_id) AS natureza_financeira,
		(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = frt.financial_operation_id) AS operacao_financeira
		

FROM financial_receivable_titles AS frt 
		JOIN contracts AS c ON c.id = frt.contract_id
		JOIN people AS p ON p.id = c.client_id
WHERE 
		frt.p_is_receivable = TRUE 
		AND frt.origin = 7
		AND frt.financial_collection_type_id IN (81,46,47,48,49,50,51,52,68,70,97,129)
		AND DATE (frt.expiration_date) <= '2025-12-31'

