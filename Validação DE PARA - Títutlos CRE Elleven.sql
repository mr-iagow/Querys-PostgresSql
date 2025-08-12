SELECT 

ba."description" AS banco,
p."name" AS cliente,
frt.competence AS competencia,
c.contract_number AS contrato,
frtt.receipt_date AS data_recebimento,
frt.expiration_date AS data_vencimento,
frt.title_amount AS valor,
frtt.fine_amount AS multa,
frtt.increase_amount AS juros,
frtt.discount_value AS desconto,
frt.issue_date AS emissao,
fo_titulo.title AS operacao_financeira,
fn.title AS natureza_financeira,
frt.origin AS origem,
frtt.amount AS recebimento,
fct.title AS tipo_cobranca,
frt.title AS titulo,
frt.title_amount AS valor_titulo


FROM financial_receivable_titles AS frt
LEFT JOIN financial_receipt_titles AS frtt ON frtt.financial_receivable_title_id = frt.id
JOIN bank_accounts AS ba ON ba.id = frt.bank_account_id
JOIN people AS p ON p.id = frt.client_id
LEFT JOIN contracts AS c ON c.id = frt.contract_id
JOIN financial_operations AS fo_titulo ON fo_titulo.id = frt.financial_operation_id
JOIN financers_natures AS fn ON frt.financer_nature_id = fn.id
JOIN financial_collection_types AS fct ON fct.id = frt.financial_collection_type_id

WHERE 

frt.company_place_id = 3
AND frt.title = 'FAT250707154740996'