SELECT DISTINCT ON (cpo.id)
cpo.contract_id AS id_contrato,
(SELECT tx.name FROM tx_types AS tx WHERE p.type_tx_id = tx.id) AS tipo_cliente,
p.name as nome_cliente,
DATE(cpo.created) AS data_cadastro,
c.v_status AS status_contrato,
p.phone AS telefone,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
CASE WHEN c.seller_1_id is null THEN (SELECT vu.name FROM v_users AS vu WHERE vu.id = cpo.created_by) ELSE (SELECT p.name FROM people AS p WHERE p.id = c.seller_1_id) END AS vendedor,
CASE WHEN c.seller_1_id IS NULL THEN (SELECT pg.title FROM people_groups AS pg WHERE pg.id = (SELECT ppg.people_group_id FROM person_people_groups AS ppg where ppg.person_id = cpo.proprietary_id))
ELSE (SELECT pg.title FROM people_groups AS pg WHERE pg.id = ppg.people_group_id) END AS equipe


FROM crm_person_oportunities AS cpo
LEFT JOIN contracts AS c ON c.id = cpo.contract_id
LEFT JOIN people AS p ON p.id = cpo.person_id
LEFT JOIN authentication_contracts AS pl ON cpo.contract_id = pl.contract_id
LEFT JOIN people_crm_informations AS org ON p.id = org.person_id
LEFT JOIN person_people_groups AS ppg ON ppg.person_id = c.seller_1_id
LEFT JOIN assignment_incidents AS ost ON cpo.assignment_id = ost.assignment_id

WHERE date(cpo.modified) BETWEEN '2024-02-02' AND '2024-02-29'
AND cpo.description IS NOT NULL
AND c.v_status = 'Bloqueio Financeiro'
AND ( CASE WHEN c.seller_1_id IS NULL THEN (SELECT ppg.people_group_id FROM person_people_groups AS ppg where ppg.person_id = cpo.proprietary_id) IN (11,14,16,28) ELSE  ppg.people_group_id IN (11,14,16,28) end)

OR

date(cpo.modified) BETWEEN '2024-02-02' AND '2024-02-29'
AND cpo.description IS NOT NULL
AND c.v_status = 'Bloqueio Financeiro'
AND ( CASE WHEN c.seller_1_id IS NULL THEN (SELECT ppg.people_group_id FROM person_people_groups AS ppg where ppg.person_id = cpo.proprietary_id) IN (11,14,16,28) ELSE  ppg.people_group_id IN (11,14,16,28) end)