SELECT 
p.name AS cliente,
(SELECT it.title FROM incident_types AS it WHERE it.id = asi.incident_type_id) AS tipo_solicitacao,
asi.protocol AS protocolo,
DATE (a.created) AS data_abertura,
(SELECT ins.title FROM incident_status AS ins WHERE ins.id = asi.incident_status_id) AS status_solicitacao,
rp.created AS data_primeiro_agendamento,
(SELECT v.name FROM v_users AS v WHERE v.id = rp.created_by) AS agendado_por,
CASE 
	WHEN a.conclusion_date IS NOT NULL THEN (SELECT v.name FROM v_users AS v WHERE v.id = a.modified_by) 
	WHEN a.conclusion_date IS NULL THEN NULL 
END AS encerrado_por,
DATE (a.conclusion_date) AS data_encerramento

FROM reports AS rp
 JOIN assignments AS a ON a.id = rp.assignment_id
 JOIN assignment_incidents AS asi ON asi.assignment_id = a.id
 JOIN people AS p ON asi.person_id = p.id

WHERE 
	DATE (rp.created) BETWEEN '2024-12-01' AND '2024-12-08'
	AND asi.incident_type_id IN (1015,1287,1924,1291)
   and rp.description LIKE '%Solicitação agendada para%'
   AND rp.created = (
  		 SELECT MIN(rp_sub.created)
        FROM reports AS rp_sub
        	WHERE 
            rp_sub.assignment_id = rp.assignment_id
            AND rp_sub.description LIKE '%Solicitação agendada para%')
