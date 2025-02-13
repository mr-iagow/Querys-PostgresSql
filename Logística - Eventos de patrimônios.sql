SELECT 
DATE (pato.created) AS data_evento,
pato."description" AS evento,
(SELECT v.name FROM v_users AS v WHERE v.id = pato.created_by) usuario

FROM patrimonies AS pat
JOIN patrimony_occurrences AS pato ON pato.patrimony_id = pat.id

WHERE 

pat.tag_number = 'PAT_00100492'

