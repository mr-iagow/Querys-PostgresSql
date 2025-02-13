SELECT DISTINCT ON (p.id)

p.id,
p.name,
p.tx_id,
p.email,
p."email_NFE",
p.situation

FROM contracts AS c
LEFT JOIN people AS p ON p.id = c.client_id

WHERE
p.email LIKE '%semdominio.com' OR p.email LIKE '%sememail.com' OR p.email LIKE 'sememail@semdominio.com'
AND c.v_status != 'Cancelado'