SELECT 
ins.title AS insiginia,
p."name" AS cliente,
p.city AS cidade,
p.neighborhood AS bairro,
p.phone AS telefone,
p.cell_phone_1 AS celular_1,
p.cell_phone_2 AS celular_2


FROM people AS p 
JOIN insignias AS ins ON ins.id = p.insignia_id

WHERE ins.id IN (36,37)