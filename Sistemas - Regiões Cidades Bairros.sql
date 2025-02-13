 SELECT DISTINCT ON (re.id)

r.title AS regiao,
(SELECT cp.description FROM companies_places AS cp WHERE cp.id = r.company_place_id) AS empresa,
rc.city AS cidade,
ne."name" AS bairro

FROM regions AS r 
LEFT JOIN region_cities AS rc ON rc.region_id = r.id
left JOIN region_relationships AS re ON re.region_id = r.id
INNER JOIN neighborhoods AS ne ON ne.id = re.neighborhood_id

WHERE r.title LIKE '%WorkZone%'
--AND r.id = 20