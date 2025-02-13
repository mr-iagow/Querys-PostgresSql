SELECT 
c.id,
c.description,
p.tx_id,
p.name,
p.name_2,
p.phone,
p.cell_phone_1,
p.cell_phone_2,
p.email,
p.city,
p.neighborhood,
p.street,
p.number,
p.address_complement,
ac.user,
acc.user,
(SELECT sp.title FROM service_products AS sp where sp.id = ac.service_product_id) AS service,
(SELECT acp.title FROM authentication_concentrators AS acp WHERE acp.id = ac.authentication_concentrator_id) AS ce,
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id) AS pe

FROM people AS p
LEFT JOIN contracts AS c ON c.client_id = p.id
LEFT JOIN authentication_contracts AS ac ON ac.contract_id = c.id
LEFT JOIN authentication_contract_connection_occurrences AS acc ON acc.contract_id = c.id
LEFT JOIN people_addresses AS pa ON pa.person_id = p.id

WHERE p.tx_id = '60496253360'
