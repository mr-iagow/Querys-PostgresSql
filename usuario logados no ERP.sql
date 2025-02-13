SELECT DISTINCT ON (v.id)

*

FROM v_users AS v 
JOIN logs AS l ON l.user_id = v.id 

WHERE 
-- v.id = 544
-- AND 
DATE (l.created) = '2023-11-14'
AND 
l.code = 4 
AND l.client_ip != 'localhost'