SELECT DISTINCT ON (frt.id)
p."name" AS cliente,
frt.title AS fatura,
frt.expiration_date AS data_vencimento,
ct.contract_number AS numero_contrato,
cev."description" AS descricao,
cev.justification AS justificativa

FROM financial_receivable_titles AS frt
JOIN contracts AS ct ON ct.id = frt.contract_id
left join contract_eventual_values AS cev ON cev.contract_id = ct.id
LEFT JOIN people AS p ON p.id = ct.client_id


WHERE DATE (frt.created) BETWEEN '2025-12-04' AND '2025-12-05'
AND frt.financial_collection_type_id = 130
AND frt.deleted = FALSE 
AND frt.title LIKE '%FAT%'
--and ct.id = 133020 
