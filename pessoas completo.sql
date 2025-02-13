SELECT 

p.id AS id_cliente,
p.name AS razao_social,
p.name_2 AS fantasia,
p.tx_id AS cpf_cnpj,
p.aliquot_irr AS aliquota_írr,
p.taxes_issqn AS taxa_issqn,
CASE 
WHEN p.taxes_issqn = 'true' THEN 'SIM'
WHEN p.taxes_issqn = 'false' THEN 'NAO'
END AS taxa_issqn,
CASE 
WHEN p.situation = 1 THEN 'contato'
WHEN p.situation = 2 THEN 'contato'
WHEN p.situation = 3 THEN 'efetivo'
WHEN p.situation = 4 THEN 'lead'
WHEN p.situation = 5 THEN 'prospect'
WHEN p.situation = 7 THEN 'suspect'
WHEN p.situation = 8 THEN 'Descartado'
END AS situacao


FROM people AS p 

WHERE p."client" = TRUE 
AND p.deleted = FALSE     
