SELECT 
p.name,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = c.company_place_id),
(SELECT acp.title FROM authentication_access_points AS acp WHERE acp.id = ac.authentication_access_point_id),
(SELECT v.name FROM v_users AS v WHERE v.id = ac.created_by),
p.neighborhood,
p.postal_code,
ac.created,
ac.integration_code,
ac.contract_id


FROM authentication_contracts AS ac 
LEFT JOIN contracts AS c ON c.id = ac.contract_id 
LEFT JOIN people AS p ON p.id = c.client_id

WHERE ac.integration_code IS NULL 
--AND ac.authentication_access_point_id = 152

