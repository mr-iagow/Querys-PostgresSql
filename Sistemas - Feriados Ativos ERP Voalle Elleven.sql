SELECT 

hd."description" AS feriado,
hd.date AS data_feriado,
CASE WHEN hd."active" = TRUE THEN 'Ativo' ELSE 'Inativo' END AS ativo

FROM holidays AS hd

WHERE 

hd."active" = TRUE
AND hd.date >= '2025-08-01'