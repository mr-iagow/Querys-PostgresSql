SELECT DISTINCT ON (p.id)

p."name" AS cliente,
c.id AS id_contrato,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2,
pa.city AS cidade,
c.v_status

FROM people AS p
JOIN people_addresses AS pa ON pa.person_id = p.id
JOIN contracts AS c ON c.client_id = p.id AND c.people_address_id = pa.id

WHERE 

pa.code_city_id IN (2302909, 2307700, 2304954, 2301208, 2301950)
AND c.v_status != 'Cancelado'