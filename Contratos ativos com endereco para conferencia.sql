SELECT 

p.id AS id,
p.name AS cliente,
p.city AS municipio,
p.code_city_id AS ibge,
p.postal_code AS cep

FROM authentication_contracts AS ac
LEFT JOIN contracts AS c ON c.id = ac.contract_id
LEFT JOIN people AS p ON p.id = c.client_id


