SELECT 

p.name,
pg.title

FROM people AS p 
JOIN person_people_groups AS ppg ON ppg.person_id = p.id 
left jOIN people_groups AS pg ON pg.id = ppg.people_group_id

WHERE 
p.collaborator = TRUe