SELECT DISTINCT ON (inv.id)

inv.document_number AS nota,
inv.company_place_name AS empresa,
inv.client_name AS cliente,
c.contract_number AS contrato,
sp.title AS item_nota,
sp."code",
(SELECT fo.title FROM financial_operations AS fo WHERE fo.id = c.operation_id) AS operacao_contrato,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = c.financer_nature_id) AS nautreza_contrato,
(SELECT fct.title FROM financial_collection_types AS fct WHERE fct.id = c.financial_collection_type_id) AS tipo_cobranca,
(SELECT op.title FROM financial_operations AS op WHERE op.id = ag.financial_operation_id) AS operacao_agrupador,
(SELECT fn.title FROM financers_natures AS fn WHERE fn.id = ag.financer_nature_id) AS nautreza_agrupador,
inv.total_amount_gross AS valor_bruto,
inv.total_amount_liquid AS valor_liquido,
inv.discounts AS descontos,
inv.additions AS acrescimos,
inv.issqn_amount AS issqn,
inv.pis_amount as pis,
inv.cofins_amount AS cofins,
inv.csll_amount AS csll,
inv.irrf_amount AS irrf,
inv.inss_amount AS inss,
inv.icms_amount AS icms,
inv.base_icms_amount AS bc_icms,
inv.xml_url,
inv.print_url AS link_espelho_nota,
inv.sefaz_consult_url,
inv.sefaz_qr_code_consult_url

FROM invoice_notes AS inv
LEFT JOIN contracts AS c ON c.id = inv.contract_id
LEFT JOIN contract_configuration_billings AS ag ON ag.contract_id = c.id
LEFT JOIN contract_items AS serv ON ag.id = serv.contract_configuration_billing_id AND serv.deleted = FALSE
LEFT JOIN invoice_note_items AS invt ON invt.invoice_note_id = inv.id
LEFT JOIN service_products AS sp ON sp.id = invt.service_product_id

WHERE 

inv."status" = 3