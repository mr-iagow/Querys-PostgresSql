SELECT DISTINCT ON (c.id, cev.id, frt.id,ai.protocol)
c.id AS id_contrato,
ai.protocol AS protocolo_instalacao,
(SELECT it.title FROM incident_types AS it WHERE it.id = ai.incident_type_id) AS tipo_instalacao,
LAST_VALUE(r.description) OVER (PARTITION BY a.id ORDER BY r.created ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS relato_encerramento,
a.description AS relato_abertura,
p.name AS cliente,
CASE
	WHEN pu.title IS NULL THEN 'Sem Contrato De Fidelidade/Termo Adesão Vinculado' ELSE pu.title END AS termo_adesao_pessoas_completo,
DATE (pu.created) AS data_vinculo_termo_contrato,

CASE
	WHEN p.csll_deducted = 0 THEN 'Sem Retenção'
	WHEN p.csll_deducted = 1 THEN 'Normal'
	WHEN p.csll_deducted = 2 THEN 'Reter Sempre'
END AS pis_cofins_csll,

CASE
	WHEN p.retains_income_tax = 0 THEN 'Sem Retenção'
	WHEN p.retains_income_tax = 2 THEN 'Normal'
	WHEN p.retains_income_tax = 1 THEN 'Reter Sempre'
END AS retem_ir,
CASE 
	WHEN p.taxes_municipality = 1 THEN 'Sim'
	WHEN p.taxes_municipality = 2 THEN 'Não'
END AS tributa_no_municipio,
CASE 
	WHEN p.taxes_issqn = TRUE THEN 'Sim'
	WHEN p.taxes_issqn = FALSE THEN 'Não'
END AS tributa_issqn,
CASE 
	WHEN p.resp_retains= TRUE THEN 'Sim'
	WHEN p.resp_retains = FALSE THEN 'Não'
END AS prestado_responsavel_retencao,
p.tax_percentage AS aliquota_issqn,
pa.city AS cidade_vinculada_contrato,
pa.neighborhood AS bairro_vinculado_contrato,
p.email,
cty.title AS tipo_contrato,
(SELECT v.name FROM v_users AS v WHERE v.id = caa.modified_by) AS contrato_aprovado_por,
CASE 
	WHEN ce.created = '0001-01-01 00:00:00' 
	THEN DATE(ce.date) 
	WHEN ce.created != '0001-01-01 00:00:00' 
	THEN DATE(ce.created) 
END AS data_aprovacao,
sp.title AS plano,
CASE 
  WHEN c.discount_use_contract = 1 THEN 'Conforme Contrato'
  WHEN c.discount_use_contract = 0 THEN 'Conforme Tipo De Cobrança'
  WHEN c.discount_use_contract = 2 THEN 'Não Aplica Desconto'
END AS possui_desconto_no_contrato,
caa.activation_date AS data_ativacao,
cp.description AS empresa,
c.collection_day AS dia_vcto_contrato,
c.billing_beginning_date AS faturar_de_inicial,
c.billing_final_date AS faturar_de_final,
c.beginning_date AS vigencia_contrato_inicial,
c.final_date AS vigencia_contrato_final,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS natureza_contrato,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.second_financial_operation_id) AS operacao_secundaria_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS natureza_agrupador,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = ag.financial_collection_type_id) AS tipo_cobranca_agrupador,
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = ag.financial_operation_id) AS teste_operacao,
c.observation AS observacoes_contrato,
(SELECT v.name FROM v_users AS v WHERE v.id = cev.created_by) AS usuario_criador_eventual,
cev.total_amount AS valor_eventual,
cev.description AS descricao_eventual,
cev.justification AS justificativa

FROM contracts AS c
INNER JOIN people AS p ON c.client_id = p.id
LEFT JOIN contract_items AS con ON c.id = con.contract_id
INNER JOIN contract_events AS ce ON c.id = ce.contract_id
INNER JOIN contract_event_types AS cet ON cet.id = ce.contract_event_type_id
left JOIN contract_assignment_activations AS caa ON caa.contract_id = c.id
JOIN companies_places AS cp ON cp.id = c.company_place_id
left JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id AND ag.financial_collection_type_id IS NOT NULL AND ag.financer_nature_id IS NOT NULL AND ag.deleted = false 
JOIN people_addresses AS pa ON pa.id = c.people_address_id
LEFT JOIN people_uploads AS pu ON pu.people_id = p.id AND pu.documentation_type_id = 8
JOIN contract_items AS ci ON ci.contract_id = c.id AND ci.deleted = FALSE 
JOIN service_products AS sp ON sp.id = ci.service_product_id AND sp.huawei_profile_name IS NOT NULL
left JOIN contract_eventual_values AS cev ON cev.contract_id = c.id AND cev.deleted = FALSE
LEFT JOIN financial_receivable_titles AS frt ON frt.contract_id = c.id AND frt.financer_nature_id = 103 AND frt.title LIKE '%FAT%'
left JOIN assignments AS a ON a.requestor_id = c.client_id
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id AND ai.incident_type_id IN (1900,2175,1899,1971,2288,1970,1901) AND ai.incident_status_id = 4
JOIN reports AS r ON r.assignment_id = a.id
JOIN contract_types AS cty ON cty.id = c.contract_type_id

WHERE date(ce.created) BETWEEN '2025-07-01' AND '2025-07-29' -- Data de aprovação dos contratos no ERP VOALLE
AND ce.contract_event_type_id = 3
--AND c.id = 122190 -- Evento de aprovacao do ERP VOALLE