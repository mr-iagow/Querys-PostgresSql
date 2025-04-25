SELECT 
    v."name" AS nome,
    CONCAT(
        SUBSTRING(v.tx_id FROM 1 FOR 3), '.',
        SUBSTRING(v.tx_id FROM 4 FOR 3), '.',
        SUBSTRING(v.tx_id FROM 7 FOR 3), '-',
        SUBSTRING(v.tx_id FROM 10 FOR 2)
    ) AS cpf,
    v.email
FROM v_users AS v
WHERE 
    v."active" = TRUE 
    AND v.deleted = FALSE
    AND v.id NOT IN (501,269);
