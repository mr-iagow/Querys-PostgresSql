SELECT 

*

FROM assignments AS a
JOIN assignment_incidents AS ai ON ai.assignment_id = a.id 
LEFT JOIN authentication_sites AS asu ON asu.id = ai.authentication_site_id

WHERE 

asu.id = 305