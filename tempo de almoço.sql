SELECT 

(SELECT it.title FROM incident_types AS it WHERE it.id = asi.incident_type_id) AS tipo_solicitacao,
asi.protocol AS protocolo,
v.name AS tecnico,
p.name AS nome_cliente, 
r.description AS relato_técnico,
r.title AS evento,
r.created AS hora_incio_almoco,
r.modified AS hora_termino_almoco,
(r.modified - r.created) AS tempo_de_pausa,
(SELECT ins.title FROM incident_status AS ins where ins.id = asi.incident_status_id) AS status_atual,
(SELECT t.title FROM teams AS t WHERE t.id = v.team_id) AS equipe_tecnico

FROM assignments AS a 
JOIN 
	assignment_incidents AS asi ON asi.assignment_id = a.id
JOIN 
	reports AS r ON r.assignment_id = a.id 
JOIN 
	people AS p ON p.id = a.requestor_id
JOIN 
	v_users AS v ON v.id = r.created_by

WHERE 
v.name = 'FRANCISCO IAGO OLIVEIRA'
AND asi.incident_type_id =  1232
AND asi.incident_status_id = 4