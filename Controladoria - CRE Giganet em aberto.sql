SELECT DISTINCT ON (frt.title)

frt.title AS fatura,
frt.title_amount AS valor_fatura,
ct.contract_number AS numero_contrato,
ct.v_status AS status_contrato,
ctr.title AS tipo_contrato,
p."name" AS cliente,
frt.competence AS competencia,
frt.complement AS complemento_fatura,
frt.expiration_date AS vencimento,
p.street AS rua,
p."number" AS numero,
p.neighborhood AS bairro,
p.city AS cidade


FROM financial_receivable_titles AS frt 
LEFT JOIN contracts AS ct ON ct.id = frt.contract_id
JOIN contract_types AS ctr ON ctr.id = ct.contract_type_id
LEFT JOIN people AS p ON p.id = ct.client_id
LEFT JOIN people_addresses AS pa ON pa.person_id = ct.people_address_id

WHERE frt.deleted = FALSE 
AND ct.contract_type_id IN (35,36,37,38,39,45) 
AND frt.title LIKE '%FAT%' 
AND frt.p_is_receivable = TRUE 