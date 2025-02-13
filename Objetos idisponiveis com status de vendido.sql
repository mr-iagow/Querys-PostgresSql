SELECT DISTINCT ON (pat.id)

pat.id,
pat.title,
pat.serial_number,
pat.tag_number,
pat.last_occurrence_description

FROM patrimonies AS pat 
JOIN patrimony_occurrences AS pato ON pato.patrimony_id = pat.id

WHERE 

pat.last_accurrence_type = 28
AND pat.situation = 0
