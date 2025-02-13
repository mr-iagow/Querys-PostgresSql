SELECT DISTINCT ON (ct.id)

ct.id  AS id_contrato,
p.id AS id_cliente,
p."name" AS nome_cliente,
ct.v_stage AS estagio_contrato,
ct.v_status AS status_contrato,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = ct.company_place_id) AS local_contrato,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = p.company_place_id) AS local_pessoas_completo


FROM contracts AS ct
LEFT JOIN people AS p ON p.id = ct.client_id

WHERE 

ct.v_status != 'Cancelado'