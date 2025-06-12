SELECT 
p."name" AS colaborador,
sp.title AS produto,
v.balance AS quantidade_sob_posse

FROM person_product_movimentation_view AS v
JOIN service_products AS sp ON sp.id = v.service_product_id
JOIN people AS p ON p.id = v.person_id

WHERE 

v.balance > 0
AND p."name" ='KELTON CLEMENTE DOS SANTOS'